
import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.8.0/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "A user can say ect",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployer = accounts.get('deployer')!.address;
        const user = accounts.get('wallet_1')!.address

        let block = chain.mineBlock([
            Tx.contractCall(
                "ect",
                "say-ect",
                [],
                user
            )
        ]);
        assertEquals(block.receipts.length, 1);
        assertEquals(block.height, 2);

        const messageMapped = chain.callReadOnlyFn(
            "ect",
            "get-ect",
            [types.principal(user)],
            user
        )
        assertEquals(messageMapped.result, types.some(types.ascii("ect")));

        const totalCountIncreased = chain.callReadOnlyFn(
            "ect",
            "get-total-ects",
            [],
            user
        )
        assertEquals(totalCountIncreased.result, types.uint(1));
    },
});
