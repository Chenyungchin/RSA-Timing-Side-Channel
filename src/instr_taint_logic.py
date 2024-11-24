# assume the input file is a flattened single module 
# verilog file with only ``&'', ``~'', ``='', and ``<=''
import itertools
import re
import textwrap
from collections import defaultdict
from collections.abc import Callable
from dataclasses import dataclass

RegId = str
WireId = str

@dataclass
class Reg:
    name: str
    width: str = ""
    
@dataclass
class Wire:
    name: str
    width: str = ""
    

@dataclass
class TaintLogicConfig:
    """Settings for taint logic generation"""

    parse_reg: Callable  # [[str], Reg | None]
    parse_wire: Callable  # [[str], Wire | None]
    operations: set  # {"&", "~", ...}  
    
    
def t_name(name: str) -> str:
    return f"{name}__t"
    
def add_taint_logic(filein, fileout, *, cfg: TaintLogicConfig):
    commentp = re.compile(r"\(\*.*\*\)")
    comments = re.compile(r"/\*.*\*/")
    comment = re.compile(rf"({commentp.pattern}|{comments.pattern})")
    skip = re.compile(rf"(\s|{comment.pattern})*")
    skipline = re.compile(rf"^{skip.pattern}$")

    module_decl = re.compile(r"\s*(module)\s+(.+)\((.*)\).*;")
    decl = re.compile(r"\s*(module|wire|reg|input|output|inout).*;")
    decl_reg = re.compile(r"\s*reg .*")
    decl_wire = re.compile(r"\s*(wire|input|output|inout) .*")
    
    assign = re.compile(
        r"(?P<lhs>\s*(assign )?(?P<var>[\w\.\\]+)\s*(\[[0-9:\s]*\])?\s*(=|<=))"
        rf"\s*(?P<rhs>.+);(?P<comments>{skip.pattern})"
    )
    endmodule = re.compile(r"\s*endmodule")
    
    const = re.compile(r"\d+\'[b|h][0-9a-fA-F]+")


    with open(filein, "r") as fin, open(fileout, "w") as fout:
        fout.write("/* Added taint logics via instr_taint_logic.py */\n")
        lines = iter(fin)
        
        for l in lines:
            if match := decl.match(l):
                assert match.group(1) == "module", "module declaration must be first"
                match = module_decl.match(l)
                module_name = match.group(2)
                arg_str = match.group(3)
                mod_args = arg_str.split(",")
                line = f"module {module_name}_taint ({mod_args[0]}, {t_name(mod_args[0])}"
                for arg_name in mod_args[1:]:
                    arg_name = arg_name.strip()
                    line += f", {arg_name}, {t_name(arg_name)}"
                line += ");\n"
                fout.write(line)
                break
            else:
                fout.write(l)
        
        # handling wire/reg/input/output declarations
        for l in lines:
            if skipline.match(l):
                fout.write(l)
                continue

            if not decl.match(l):
                lines = itertools.chain([l], lines)
                break

            if decl_reg.match(l) and (reg := cfg.parse_reg(l)):
                fout.write(l)
                tainted_name = t_name(reg.name)
                if reg.width:
                    fout.write(f"  reg {reg.width} {tainted_name};\n")
                else:
                    fout.write(f"  reg {tainted_name};\n")
                    
            if decl_wire.match(l) and (wire := cfg.parse_wire(l)):
                fout.write(l)
                tainted_name = t_name(wire.name)
                if "input" in l:
                    if wire.width:
                        fout.write(f"  input {wire.width} {tainted_name};\n")
                    else:
                        fout.write(f"  input {tainted_name};\n")
                elif "output" in l:
                    if wire.width:
                        fout.write(f"  output {wire.width} {tainted_name};\n")
                    else:
                        fout.write(f"  output {tainted_name};\n")
                else:
                    if wire.width:
                        fout.write(f"  wire {wire.width} {tainted_name};\n")
                    else:
                        fout.write(f"  wire {tainted_name};\n")

        # handling assign statements



if __name__ == '__main__':
    import argparse
    import sys
    
    parse = argparse.ArgumentParser()
    parse.add_argument(
        "--input", dest="input_path", required=True, help="input verilog file"
    )
    parse.add_argument(
        "--output",
        dest="output_path",
        required=True,
        help="output verilog file",
    )
    
    args = parse.parse_args()
    if not args.input_path.endswith(".v") and not args.input_path.endswith(".sv"):
        print("Invalid input file, must be a .v or .sv file")
        sys.exit(1)
    if not args.output_path.endswith(".v") and not args.output_path.endswith(".sv"):
        print("Invalid input file, must be a .v or .sv file")
        sys.exit(1)
        
    width_re = r"\s*(?P<width>(\[\d+:\d+\]|))\s*"
    name_re = r"(?P<name>[\w\.\\]+)"
    reg_re = re.compile(rf"\s*reg{width_re} {name_re}")
    wire_re = re.compile(rf"\s*(wire|input|output|inout){width_re} {name_re}")
    
    def parse_reg(reg: str):  # -> RegCopy | None:
        match = reg_re.match(reg)
        if match is None:
            return None
        try:
            return Reg(
                match.group("name"),
                width=match.group("width")
            )
        except KeyError:
            return None
    
    def parse_wire(wire: str):  # -> WireCopy | None:
        match = wire_re.match(wire)
        if match is None:
            return None
        try:
            return Wire(
                match.group("name"),
                width=match.group("width")
            )
        except KeyError:
            return None
    
    config = TaintLogicConfig(
        parse_reg=parse_reg,
        parse_wire=parse_wire,
        operations={"&", "~"}
    )
    
    add_taint_logic(args.input_path, args.output_path, cfg=config)