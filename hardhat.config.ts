import '@nomiclabs/hardhat-ethers'
import '@nomiclabs/hardhat-waffle'
import '@nomiclabs/hardhat-etherscan'
import '@typechain/hardhat'

import { parseUnits } from 'ethers/lib/utils'

import { HardhatUserConfig, task } from 'hardhat/config'

const mnemonic = process.env.DEV_MNEMONIC as string

task('deploy-tulip').setAction(async (args, { ethers, run }) => {
  // compile

  await run('compile')

  // get signer

  const signer = (await ethers.getSigners())[0]
  console.log('Signer')
  console.log('  at', signer.address)

  // deploy contracts

  const owner = '0x777B0884f97Fd361c55e472530272Be61cEb87c8'
  const recipients = [
    '0x81c50923af7D892D1EC65A84Ec64c85430FdC7bf',
    '0x2B1634a6a6cB9cB61aC684891Dd122f4f542b05D',
    '0x360059bBD6Df9AE032e93A8E5Fa7900BBd10363A',
    '0x070dcb7ba170091f84783b224489aa8b280c1a30',
    '0xFA10ceA919C9E403d150318ee0eccdEC57c0d941',
    '0x9Bd430B4A63178EA29ADFecA33E37f1094FF3B05',
    '0xc7bd798519B38F4d9F424F8764424C54F653C38a',
    '0xb69C80B34aEe8e42A69047be6AE59e3729Ce0ccC',
    '0x57E84E24A6e85941d956D761055484Dfd2b99014',
    '0xFe8181d29aDe53FD27AE3cAD4f9b6477B42897c3',
    '0x59b99F16772ab9f4c10dB9eb009606D644144B5B',
    '0x7AAB47892181338538CeDAf0f9b119C3215771c3',
    '0xBfd2c7B0e0E18558439448c2Dfd652d8Cea6F97E',
  ]
  const shareBPS = [
    5000, 2000, 700, 125, 500, 300, 200, 700, 300, 100, 25, 25, 25,
  ]

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

task('deploy-bidding').setAction(async (args, { ethers, run }) => {
  // compile

  await run('compile')

  // get signer

  const signer = (await ethers.getSigners())[0]
  console.log('Signer')
  console.log('  at', signer.address)

  // deploy contracts

  const constructorArgs = [
    '0x360059bBD6Df9AE032e93A8E5Fa7900BBd10363A',
    '500',
    '0xd5fbd81cef9aba7464c5f17e529444918a8ecc57',
  ]

  const tulipBidding = await (
    await ethers.getContractFactory('TulipBidding', signer)
  ).deploy(constructorArgs[0], constructorArgs[1], constructorArgs[2])

  console.log('Deploying TulipBidding')
  console.log('  to', tulipBidding.address)
  console.log('  in', tulipBidding.deployTransaction.hash)

  const tulipFloorBidding = await (
    await ethers.getContractFactory('TulipFloorBidding', signer)
  ).deploy(constructorArgs[0], constructorArgs[1], constructorArgs[2])

  console.log('Deploying TulipFloorBidding')
  console.log('  to', tulipFloorBidding.address)
  console.log('  in', tulipFloorBidding.deployTransaction.hash)

  // verify source

  console.log('Verifying source on etherscan')

  await tulipFloorBidding.deployTransaction.wait(2)

  await run('verify:verify', {
    address: tulipBidding.address,
    constructorArguments: constructorArgs,
  })

  await run('verify:verify', {
    address: tulipFloorBidding.address,
    constructorArguments: constructorArgs,
  })
})

export default {
  networks: {
    hardhat: {
      accounts: {
        mnemonic,
      },
      forking: {
        url: process.env.ETHEREUM_ARCHIVE_URL as string,
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
