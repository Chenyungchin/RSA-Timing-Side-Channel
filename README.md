# RSA-Timing-Side-Channel
This project aims to investigate on timing side-channel on RSA hardware algorithms using self-composition and taint analysis. Our works are listed as follows:
* Implemented an RSA module (that is prone to timing side-channel) using Verilog
* Instantiated two RSA modules and Carried out self-composition using JasperGold to check possible information leakage
* Synthesized the RSA module into gate-level netlist and added taint signals for taint analysis using JasperGold to check possible information leakage
* Based on the counter-examples provided in self-composition and taint analysis, implemented an RSA module that is resilient to timing side-channel.

## Verilog Implementation
Our RSA module did the following three tasks:
* **Key Generation**: Given two prime numbers $p$ and $q$, it generates a public key $e$ and private key $d$ such that $gcd(e, \phi) = 1$ and $e*d (mod \phi) = 1$, where $\phi = (p-1)(n-1)$. The public key $e$ is initialized to $3$ and is updated by $e=e+2$ until we find the first valid value. The private key $d$ is computed using the extended euclidean algorithm. 
* **Encryption**: Given the original message $m$, public key $e$, and $n (=p*q)$, it computes the encrypted message $c=m^e (mod n)$. It is implemented using modular multiplication.
* **Decryption**: Given the encrypted message $c$, private key $e$, and $n (=p*q)$, it computes the decrypted message $m\_{decrypted}=c^d (mod n)$. It is implemented also using modular multiplication.

Default bit width: 
* prime numbers p, q: 8 bits
* original and encrypted messages m, c: 16 bits

## Taint Analysis
For taint analysis, we first synthesize the input RTL module ($\texttt{rtl.v}$) into gate-level netlist with the Yosys synthesis tool and elaborate the gate-level netlist with gate-level taint logic, resulting in the tainted module $\texttt{tainted.v}$. 
Then the model checking is performed using the commercial model checker JasperGold with a TLC file specifying the parameters of the verification engines, assumptions, and assertions for the constant-time property.

## Self Composition
Similar to taint analysis, self-composition is done by querying model checking on the self-composition module ($\texttt{sc.v}$) converted from the input RTL ($\texttt{rtl.v}$).

## Verilog Hierarchy
For Self-Composition:
```
RSA_sc
├── RSA
│   ├── KeyGen
|   |   ├── Mult
|   |   ├── gcd
|   |   |   └── Divide
│   ├── RSA_encrypt
|   |   ├── Mult
|   |   └── Divide
│   ├── RSA_encrypt
|   |   ├── Mult
|   |   └── Divide
└── CheckPrime
```
For Taint Analysis:
```
RSA_taint
├── RSA_t (RSA module that is first flattened to AIG and then parsed with taint logic)
└── CheckPrime
```

## Taint Propagation Logic Instrumentation

(1) Flatten the Verilog modules into AIG
```
yosys ./scripts/synth2aig
```
(2) Add taint propagation logic
```
./scripts/add_taint_logic.sh
```

## How to run the code
* Verification with JasperGold's SPV
```
./scripts/jg.sh ./scripts/spv_verify.tcl    
```
* Verification with self-composition
```
./scripts/jg.sh ./scripts/sv_verify.tcl
```
* Verification with taint analysis
```
./scipts/jg.sh ./scripts/taint_verify.tcl
```

## How to specify either the insecure of the secure RSA core for verification
* Insecure RSA: In `verilog/files.f`, uncomment the insecure RSA modules and comment the secure ones.
```
./verilog/insecure_modules/Divide.v
./verilog/insecure_modules/gcd.v
./verilog/insecure_modules/KeyGen.v
./verilog/insecure_modules/Mult.v
./verilog/insecure_modules/RSA_decrypt.v
./verilog/insecure_modules/RSA_encrypt.v
./verilog/RSA.v
./verilog/RSA_sc.v
./verilog/RSA_spv.v
./verilog/CheckPrime.v
./verilog/CheckPrime_comb.v
```
* Secure RSA: In `verilog/files.f`, uncomment the secure RSA modules and comment the insecure ones.
```
./verilog/secure_modules/Divide.v
./verilog/secure_modules/gcd.v
./verilog/secure_modules/KeyGen.v
./verilog/secure_modules/Mult.v
./verilog/secure_modules/RSA_decrypt.v
./verilog/secure_modules/RSA_encrypt.v
./verilog/RSA.v
./verilog/RSA_sc.v
./verilog/RSA_spv.v
./verilog/CheckPrime.v
./verilog/CheckPrime_comb.v
```

## How to change the RSA bit-width
* Taint Analysis: change the default bit-width of the RSA module in `RSA.v`
  ```
  module RSA #(parameter WIDTH = YOUR_SPECIFIED_WIDTH)(
  ...
  ```
* Self-Composition: change the default bit-width of the RSA module in `RSA_sc.v`
  ```
  module RSA_sc #(parameter WIDTH = YOUR_SPECIFIED_WIDTH)(
  ...
  ```
* JasperGold's SPV: change the default bit-width of the RSA module in `RSA_spv.v`
  ```
  module RSA_spv #(parameter WIDTH = YOUR_SPECIFIED_WIDTH)(
  ...
  ```

### Please see our project report for more details.
https://github.com/Chenyungchin/RSA-Timing-Side-Channel/blob/main/document/project%20report.pdf
