import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-etherscan'

import { HardhatUserConfig, task } from 'hardhat/config'

const mnemonic = process.env.DEV_MNEMONIC as string

task('deploy').setAction(async (args, { ethers, run }) => {
  // compile

  await run('compile')

  // get signer

  const signer = (await ethers.getSigners())[0]
  console.log('Signer')
  console.log('  at', signer.address)

  // deploy contracts

  const owner = '0x777B0884f97Fd361c55e472530272Be61cEb87c8'
  const recipients = [
    '0x777B0884f97Fd361c55e472530272Be61cEb87c8',
    '0x777B0884f97Fd361c55e472530272Be61cEb87c8',
  ]
  const shareBPS = [5000, 5000]

  const feeRecipient = await (
    await ethers.getContractFactory('StreamETH', signer)
  ).deploy(owner, recipients, shareBPS)

  const ethertulip = await (
    await ethers.getContractFactory('EtherTulip', signer)
  ).deploy(feeRecipient.address)

  console.log('Deploying EtherTulip')
  console.log('  to', ethertulip.address)
  console.log('  in', ethertulip.deployTransaction.hash)

  // verify source

  console.log('Verifying source on etherscan')

  await ethertulip.deployTransaction.wait(5)

  await run('verify:verify', {
    address: feeRecipient.address,
    constructorArguments: [owner, recipients, shareBPS],
  })

  await run('verify:verify', {
    address: ethertulip.address,
    constructorArguments: [feeRecipient.address],
  })
})

export default {
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
      },
    },
    goerli: {
      url: ('https://goerli.infura.io/v3/' + process.env.INFURA_ID) as string,
      accounts: {
        mnemonic,
      },
    },
    mainnet: {
      url: ('https://mainnet.infura.io/v3/' + process.env.INFURA_ID) as string,
      accounts: {
        mnemonic,
      },
    },
  },
  solidity: {
    compilers: [
      {
        version: '0.8.7',
      },
    ],
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_APIKEY as string,
  },
} as HardhatUserConfig
