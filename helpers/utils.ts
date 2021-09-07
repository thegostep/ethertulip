export async function forkAtBlock(block: number) {
  const hre = require('hardhat')
  await hre.network.provider.request({
    method: 'hardhat_reset',
    params: [
      {
        forking: {
          jsonRpcUrl: process.env.ETHEREUM_ARCHIVE_URL,
          blockNumber: block,
        },
      },
    ],
  })
}

export async function setTimestamp(timestamp: number) {
  const hre = require('hardhat')
  await hre.network.provider.request({
    method: 'evm_setNextBlockTimestamp',
    params: [timestamp],
  })
}

export async function impersonateAccount(account: string) {
  const hre = require('hardhat')
  await hre.network.provider.request({
    method: 'hardhat_impersonateAccount',
    params: [account],
  })
}
