// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MysticalVaultFix {
    struct Signature {
        bytes32 hash;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    mapping(bytes32 => bool) public lapsed;
    address owner = address(0xFACE);

    function redeem(Signature[] calldata sigs) public {
        for (uint i = 0; i < sigs.length; i++) {
            Signature calldata sig = sigs[i];
            require(owner == ecrecover(sig.hash, sig.v, sig.r, sig.s), 'Invalid signature');
            require(!lapsed[sig.hash], 'Signature lapsed');
            lapsed[sig.hash] = true;
        }
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
