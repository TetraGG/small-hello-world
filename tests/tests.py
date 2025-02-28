#!/bin/env python

import argparse
import enum
import sys
import subprocess
import yaml


def check_output(module: str, custom_command=None) -> bool:
  if custom_command is None:
    custom_command = []
  process = subprocess.run([module] if custom_command == [] else custom_command, capture_output=True, text=True)
  if process.returncode != 0:
    print(module + " error on return code " + str(process.returncode) + " != 0" + "\nstdout={" + process.stdout + "}" + "\nstderr={" + process.stderr + "}")
    return False
  if process.stdout != "Hello, World!\n":
    print(module + " error on stdout " + "\nstdout={" + process.stdout + "}" + "\nstderr={" + process.stderr + "}")
    return False
  return True


def check_size(module: str) -> int:
  process = subprocess.run(["wc", "-c", module], capture_output=True, text=True)
  if process.returncode != 0:
    print(
        "unexpected error on counting bytes returncode=" + str(process.returncode) + "\nstdout={" + process.stdout + "}" + "\nstderr={" + process.stderr + "}")
    return -1
  return int(process.stdout.split(' ')[0])


def compiled(modules: list[str]) -> dict[str, int]:
  results: dict[str, int] = {}
  for module in modules:
    if not check_output(module):
      continue
    byte_count = check_size(module)
    if byte_count != -1:
      results[module.split('/')[0]] = byte_count
  return results


class LanguageType(enum.Enum):
  Unknown = 0
  Java = 1

  @staticmethod
  def get_type(module: str):
    if module.startswith('java'):
      return LanguageType.Java
    else:
      return LanguageType.Unknown

  def get_command(self, module) -> list[str]:
    match self:
      case LanguageType.Java:
        return ["java", "-jar", module]
      case LanguageType.Unknown:
        return []

  def get_cwd(self) -> str:
    match self:
      case LanguageType.Java:
        return "java"
      case LanguageType.Unknown:
        return ""


def semi_compiled(modules: list[str]) -> dict[str, int]:
  results: dict[str, int] = {}
  for module in modules:
    language = LanguageType.get_type(module)
    if language == LanguageType.Unknown:
      print("Error on unknown language " + module)
      continue
    if not check_output(module, language.get_command(module)):
      continue
    byte_count = check_size(module)
    if byte_count != -1:
      results[module.split('/')[0]] = byte_count
  return results


def interpreted(modules: list[str]) -> dict[str, int]:
  results: dict[str, int] = {}
  for module in modules:
    if not check_output(module):
      continue
    byte_count = check_size(module)
    if byte_count != -1:
      results[module.split('/')[0]] = byte_count
  return results


if __name__ == "__main__":
  parser = argparse.ArgumentParser(prog='Tiny Hello World Tester', description='Check validity of generated binaries')
  parser.add_argument('-ss', '--skip_size_check', action="store_true")
  parser.add_argument('-c', '--compiled', nargs='+', default=[])
  parser.add_argument('-sc', '--semi-compiled', nargs='+', default=[])
  parser.add_argument('-i', '--interpreted', nargs='+', default=[])
  args = parser.parse_args()
  module_results: dict[str, int] = {}
  mode: str = 'u'
  if args.compiled:
    module_results = compiled(args.compiled)
    mode = 'compiled'
  elif args.semi_compiled:
    module_results = semi_compiled(args.semi_compiled)
    mode = 'semi_compiled'
  elif args.interpreted:
    module_results = interpreted(args.interpreted)
    mode = 'interpreted'
  else:
    print("No arguments given")
    parser.print_help()
    sys.exit(1)
  with open('tests/data_' + mode + '.yml', 'r+') as outfile:
    ref_data: dict[str, int] = yaml.load(outfile, Loader=yaml.SafeLoader)
    for item, value in ref_data.items():
      if item not in module_results:
        print("Missing " + item + " in test data")
        sys.exit(2)
      if not args.skip_size_check and value < module_results[item]:
        print(item + " has a greater size " + str(value) + " < " + str(module_results[item]))
        sys.exit(3)
    outfile.seek(0, 0)
    yaml.dump(module_results, outfile, default_flow_style=False)
