// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/MysticalVaultFix.sol";

contract MysticalVaultFixTest is Test {
    MysticalVaultFix vault;
    address owner = address(0xFACE);
    address attacker = address(0xDEAD);

    function setUp() public {
        vault = new MysticalVaultFix();
        vm.deal(address(this), 10 ether); // Deal 10 ether to this contract
        payable(address(vault)).transfer(10 ether); // Send 10 ether to the vault
    }

    function testRedeemValidSignatures() public {
        MysticalVaultFix.Signature[] memory sigs = new MysticalVaultFix.Signature[](4);

        // Prepare signatures assuming valid inputs for demonstration
        for (uint i = 0; i < 4; i++) {
            bytes32 hash = keccak256(abi.encodePacked(i));
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint256(uint160(owner)), hash);
            sigs[i] = MysticalVaultFix.Signature(hash, v, r, s);
        }

        vault.redeem(sigs);

        assertEq(address(this).balance, 10 ether, "Balance should be transferred to the redeemer");
        assertEq(address(vault).balance, 0, "Vault balance should be zero");
    }

    function testRedeemReplayAttack() public {
        MysticalVaultFix.Signature[] memory sigs = new MysticalVaultFix.Signature[](4);

        // Prepare signatures assuming valid inputs for demonstration
        for (uint i = 0; i < 4; i++) {
            bytes32 hash = keccak256(abi.encodePacked(i));
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint256(uint160(owner)), hash);
            sigs[i] = MysticalVaultFix.Signature(hash, v, r, s);
        }

        vault.redeem(sigs);
        vm.expectRevert("Signature lapsed");
        vault.redeem(sigs); // Attempt to reuse the same signatures
    }

    function testRedeemInvalidSignatures() public {
        MysticalVaultFix.Signature[] memory sigs = new MysticalVaultFix.Signature[](4);

        // Prepare invalid signatures
        for (uint i = 0; i < 4; i++) {
            bytes32 hash = keccak256(abi.encodePacked(i));
            (uint8 v, bytes32 r, bytes32 s) = vm.sign(uint256(uint160(attacker)), hash);
            sigs[i] = MysticalVaultFix.Signature(hash, v, r, s);
        }

        vm.expectRevert("Invalid signature");
        vault.redeem(sigs);
    }
}