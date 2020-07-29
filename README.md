# Nixpkgs Crypto Overlay
Packages for crypto-currency and mining. I created this primarily for myself to automate
setting up miners.

We provide the following packages:

 * [electrum-personal-server](https://github.com/chris-belcher/electrum-personal-server)
 * [ethminer](https://github.com/ethereum-mining/ethminer) ([ROCm only](https://github.com/RadeonOpenCompute/ROCm))
 
And the following top-level NixOS options:
 
  * electrumPersonalServer
  * ethminerRocm
  * xmrig
  
## Getting Started
In order to use the NixOS module, add it to your `imports` in `configuration.nix`

    let 
      nixosCryptoGit = fetchGit {
        url = "https://github.com/sgillespie/nixpkgs-crypto-overlay.git";
      };
    in
    {
      imports = [
        # Add to existing imports
        "${nixosCryptoGit}"
      ];
    }

In order to use the overlay, add it to your `nixpkgs.overlays`

    let 
      nixosCryptoGit = fetchGit {
        url = "https://github.com/sgillespie/nixpkgs-crypto-overlay.git";
      };
    in
    {
      nixpkgs.overlays = [
        # Add to existing overlays
        (import "${nixosCryptoGit}/overlay.nix")
      ];
    }

For more information on overlays, see the [manual](https://nixos.org/nixpkgs/manual/#chap-overlays)

## Options
We provide the following options:

### Electrum Personal Server

`services.electrumPersonalServer.enable`

 * *Description:* Whether to enable Electrum Personal Server.
 * *Type*: Boolean
 * *Default:*: `false`

`services.electrumPersonalServer.masterPublicKeys`

  * *Description:* Master public keys to track
  * *Type:* Attributes of String
  * *Default:* `{}`
  * *Example:*

        {
          wallet1 = "zpub6t2yvRSJe12ntz3hB9QnWLAZwMWTXzUrLdgTLk8ssuCpQoqs9JXize9Ndek6tR2QAw6GMYRhf2cGe8ZiEXbo1SqXQdLbhrC4tvyCzSiFxdc"
          wallet2 = "zpub6td1U6nQL6i9W9TDWSFRQLqcQiTLD374ud3HQFdSBwecWRB9xBAcntrseQ13LVjwdWCF48bndSZXzaNdoxitSgDzF5gHuYLY6VeQe6LtzSL"
        }

`services.electrumPersonalServer.watchOnlyAddresses`

 * *Description:* Watch-only addresses to track
 * *Type:* Attributes of String
 * *Default:* `{}`
 * *Example:*

       {
         wallet1 = "zpub6t2yvRSJe12ntz3hB9QnWLAZwMWTXzUrLdgTLk8ssuCpQoqs9JXize9Ndek6tR2QAw6GMYRhf2cGe8ZiEXbo1SqXQdLbhrC4tvyCzSiFxdc"
         wallet2 = "zpub6td1U6nQL6i9W9TDWSFRQLqcQiTLD374ud3HQFdSBwecWRB9xBAcntrseQ13LVjwdWCF48bndSZXzaNdoxitSgDzF5gHuYLY6VeQe6LtzSL"
       }

`services.electrumPersonalServer.bitcoinRpc.user`

 * *Description:* Username for Bitcoind RPC connection
 * *Type:* String
 * *Default:* `null`

`services.electrumPersonalServer.bitcoinRpc.password`

 * *Description:* Password Bitcoind RPC connection
 * *Type:* String
 * *Default:* `null`

`services.electrumPersonalServer.bitcoinRpc.wallet`

 * *Description:* Bitcoin wallet name
 * *Type:* String
 * *Default:* `null`

### Ethminer (ROCm)

`services.ethminerRocm.enable`

 * *Description:* Whether to enable AMD Ethminer
 * *Type:* Boolean
 * *Default:* `false`

`services.ethminerRocm.apiPort`

 * *Description:* Ethminer API port. Minus sign puts the API in read-only mode.
 * *Type:* Integer
 * *Default:* `-3333`

`services.ethminerRocm.maxPower`

 * *Description:* Maximum GPU power in watts
 * *Type:* Positive Integer
 * *Default:* `110`

`services.ethminerRocm.pool`

 * *Description:* Mining pool address host
 * *Type:* String
 * *Example:* `eth-us-east1.nanopool.org`

`services.ethminerRocm.recheckInterval`

 * *Description:* Interval in milliseconds between farm rechecks
 * *Type:* Integer
 * *Default:* `2000`

`services.ethminerRocm.registerMail`

 * *Description:* URL encoded email address to register with the pool
 * *Type:* String
 * *Example:* `mail%40example.org`

`services.ethminerRocm.rig`

 * *Description:* Mining rig name
 * *Type:* String
 * *Example:* `default-worker`

`services.ethminerRocm.scheme`

 * *Description:* Mining protocol scheme
 * *Type:* String
 * *Default:* `stratum+tcp`

`services.ethminerRocm.stratumPort`

 * *Description:* Stratum protocol TCP port
 * *Type:* Port
 * *Default:* `9999`

`services.ethminerRocm.wallet`

 * *Description:* Ethereum mining address
 * *Type:* String
 * *Example:* `0x0123456789abcdef0123456789abcdef01234567`

### XMRig

`services.xmrig.enable`

 * *Description:* Whether to enable XMRig miner
 * *Type:* Boolean
 * *Default:* `false`

`services.xmrig.algorithm`

 * *Description:* XMRig mining algorithm
 * *Type:* String
 * *Default:* `rx/0`

`services.xmrig.tls`

 * *Description:* Whether to enable TLS encryption
 * *Type:* Boolean
 * *Default:* `false`

`services.xmrig.url`

 * *Description:* Mining pool address URL
 * *Type:* String
 * *Example:* `xmr-us-east1.nanopool.org:14433`

`services.xmrig.user`

 * *Description:* Username for the mining server
 * *Type:* String
 * *Example:* `44dZDgJXpRyH6BnLAWEkDq646RjVAheNmD8hb8qEkhjxAFm9NHL7PpMczStYhdQgMZMxdxiF7Yf3jY2x8fWjZKnjRvdTyCR.default/email@email.com`
