Truffle Tests Runner
===

## Dependencies
 - Node.JS/NPM
 - truffle
 - ethermint
 - geth

Usage:
  `./compare.sh file` and
  `./diff.sh`

`file` format: Each file contains repo and the directory in that repo, which should contain truffle tests and configs.
Checkout `file-example`.

`compare.sh` will setup directory in /tmp/net folder, run ethermint and tests against it. Then it will create ethermint folder, run it and test against it. Test repositories are cloned into directory /tmp/truffle-tests and test outputs are saved. `./diff.sh` will return for outputs, empty response means both are same(success).

## Test
  [Truffle Initial Repo](https://github.com/trufflesuite/truffle-init-default) tests were run against both networks. It contains simple MetaCoin implementation with it's test. Test output example:
```
NPM Install
Create migrations folder
Run Truffle Tests
Compiling ./contracts/ConvertLib.sol...
Compiling ./contracts/MetaCoin.sol...
Compiling ./contracts/Migrations.sol...
Compiling ./test/TestMetacoin.sol...
Compiling truffle/Assert.sol...
Compiling truffle/DeployedAddresses.sol...

TestMetacoin
  ✓ testInitialBalanceUsingDeployedContract (1012ms)
  ✓ testInitialBalanceWithNewMetaCoin (1012ms)

Contract: MetaCoin
  ✓ should put 10000 MetaCoin in the first account
  1) should call a function that depends on a linked library
    > No events were emitted
  ✓ should send coin correctly (1030ms)


 4 passing (5s)
 1 failing

  1) Contract: MetaCoin should call a function that depends on a linked library:
     AssertionError: Library function returned unexpected function, linkage may be broken: expected 0 to equal 20000
      at test/metacoin.js:25:14
      at process._tickDomainCallback (internal/process/next_tick.js:129:7)

```
Even though one test failed, both networks returned same result so it can be considered correct behaviour. (About failed test cases in Future Work)
