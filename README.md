# RSA-Timing-Side-Channel
This project aims to investigate on timing side channel on RSA hardware algorithms using self-composition and taint analysis. Our works are listed as follows:
* Implemented an RSA module (that is prone to timing side channel) using verilog
* Instantiated two RSA modules and Carried out self composition using JasperGold to check possible information leakage
* Synthesized the RSA module into gate level netlist and added taint signals for taint analysis using JasperGold to check possible information leakage
* Based on the counter-examples provided in self composition and taint analysis, implemented an RSA module that is resilient to timing side channel.

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
Then the model checking is performed using the commercial model checker JasperGold with a TLC file specifying the parameters of the verification engines, assumptions, and assertions for the constant time property.

## Self Composition
Similar to taint analysis, self composition is done by querying model checking on the self composition module ($\texttt{sc.v}$) converted from the input RTL ($\texttt{rtl.v}$).

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

### Please see our project report for more details.
