// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// This is a revised version of the revised version of the original EtherRock contract 0x37504ae0282f5f334ed29b4548646f887977b7cc with all the rocks removed and rock properties replaced by tulips.
// The original contract at 0x37504ae0282f5f334ed29b4548646f887977b7cc had a simple mistake in the buyRock() function where it would mint a rock and not a tulip. The line:
// require(rocks[rockNumber].currentlyForSale == true);
// Had to check for the existance of a tulip, as follows:
// require(tulips[tulipNumber].currentlyForSale == true);
// Therefore in the original contract, anyone could buy anyone elses rock whereas they should have been buying a tulip (regardless of whether the owner chose to sell it or not)

contract EtherTulip is ERC721("EtherTulip", unicode"🌷") {
    struct Tulip {
        uint256 listingTime;
        uint256 price;
        uint256 timesSold;
    }

    mapping(uint256 => Tulip) public tulips;

    uint256 public latestNewTulipForSale;

    address public immutable feeRecipient;

    event TulipForSale(uint256 tulipNumber, address owner, uint256 price);
    event TulipNotForSale(uint256 tulipNumber, address owner);
    event TulipSold(uint256 tulipNumber, address buyer, uint256 price);

    constructor(address _feeRecipient) {
        // set fee recipient
        feeRecipient = _feeRecipient;
        // mint founder tulip to yours and only
        ERC721._mint(address(0x777B0884f97Fd361c55e472530272Be61cEb87c8), 0);
        // initialize auction for second tulip
        latestNewTulipForSale = 1;
        tulips[latestNewTulipForSale].listingTime = block.timestamp;
    }

    // Dutch-ish Auction

    function currentPrice(uint256 tulipNumber) public view returns (uint256 price) {
        if (tulipNumber == latestNewTulipForSale) {
            // if currently in auction
            uint256 initialPrice = 1000 ether;
            uint256 decayPeriod = 1 days;
            // price = initial_price - initial_price * (current_time - start_time) / decay_period
            uint256 elapsedTime = block.timestamp - tulips[tulipNumber].listingTime;
            if (elapsedTime >= decayPeriod) return 0;
            return initialPrice - ((initialPrice * elapsedTime) / decayPeriod);
        } else {
            // if not in auction
            return tulips[tulipNumber].price;
        }
    }

    // ERC721

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string[100] memory bulbURIs = [
            "QmS5Pb4i72JfSsip3PPCELf9Bu3ygce9D2kGS2BEx9PPGy",
            "QmfWRhjNqyXyqEnarRRq5whaBmTm9sKJU7TxWPD39NX4TP",
            "QmX2tgEKCBgRYHPnUAm8AdNFzDJGhjRZ4ZkvQZNmgKUe2p",
            "QmSeAU7SynbUPNPNWeu8wTyV5nJGLSFk1VdequQxbvLggg",
            "QmapgjCNbJmXm1bRNFiQh5ozhMTEBwmhpukpHBiqWFMdDa",
            "QmeYh9ZkRe6ZvdFkRaTjqkdBUF6FwCtEJgAnihXj4j3v13",
            "QmQRk4TozeBtPWnHMtq3Am36LMf33PsJQyzNPTaBWHKNFS",
            "QmUSXJRyhTRxz6TA6MseGqBERXPPid3x8PVkkh99NoFv9S",
            "QmSEwpg5C2dfgxywDeCmtUVaUdKiLFKXQK8d9KCku3SF2Y",
            "QmcQJrWyt1TUjsbjZSjcD4Vz8nKsy4VseJsB8N7EvhSUPJ",
            "QmPb12GN3pcvL78NVQ6FK9AE252ChBK8gQMCzUjez7prC7",
            "QmfGXgopgkAiERmtt2inMuwvaajKv8uUow2WjVuJd8n8Cg",
            "QmRpt7sGKRSxcdpnkdLEdrQZyuMyYgoqez6mYumTdAkmbo",
            "QmSqE8AjqsiHx5baZ2M4p6mjC5Va35F65yDbkRebFaHGZu",
            "QmQ6wZHRCaFHafhyqGAK3638biAk6tz56DCAK2BLQKPTct",
            "QmT8ezQ4nuESWYMzcfbb6kcfESDDyeK2CBYp1uaRQo9xLd",
            "QmZr1z7cCTXRqYWvPSatcGZwJqSt8j6hsMxLUJBQMbnVnr",
            "QmTSuh4gznWdw3STbBVG1Ve1jynHHLpfFcdgFwJi4nqktD",
            "QmRpCGbX5eFbtDehnhatdtp7a1kzmgnkAZSJubsD5Hx7Hh",
            "QmUUDST3T2oHHrf7Sm4AbVxsh46Mt42XyV6S1AMVgFWM88",
            "QmY62Pt1923mPKaJkSLyYoSWCGYbLiyxWQoZYaMHPE8FNF",
            "QmZdDjcsxzS7vQkQiiRmtfDC5S5CAvHRELyMsAF1cPrF3Q",
            "QmQRZ6emrZyepPGSFfGXUAiHJYVRJaKU83Qyr7KcXfNsbf",
            "QmfCDeQvQJ2CwKA5VNie6LC5Ny63VdL7uy7UaZwmoJ5Cmu",
            "QmV585E22k9gJjcBeZNtYdDmoi6yfr36M9yVLdiQP3LxAD",
            "QmeNqqxdMN5AutjZWeqLQFJzfM6Vxvyi9mBHHKyEWv5r31",
            "QmX9ZoDYo5ut3icFft1UugnmkyPbZhuYYpg8yPMJzYFftU",
            "QmRJJLP1ZvPLkyenD7jx7eC798ndeFQyv22rsCaSViLN6k",
            "QmRbt7LFyAAuCMnv9sAhKRtUrUMSrSQYuFPtPNhpSsjgmq",
            "QmQNy8Y83KonKfB59kzhvr9eQ4DjC77mJEjuPUpNRKTiKK",
            "QmZiUEGNKZwQZqrKnDV698hjxT2E4vLuq16Ps3potVDAo8",
            "QmQUxDwfRXyErr8pUcfKaxjCJwUj7SiE9DLrrJHqL9wCxa",
            "QmWrkTnGULvc9m7hUub5ss6H1oTfixfixjdgkbrbvxpKNr",
            "Qmd8eNduEprDi1JX8NUwDXDBDuXcGPmBM3fa1xH5yuMf8d",
            "QmYKXfA6LsVa28Xn2fLz435Smzm4N6FeJ1k3oVhrmvnAJF",
            "Qmf6xbzaQ1P6StboKGApSkuDoXeB5cZ61wotLT5Lz1UR9G",
            "QmZVE4KyoFViMApkgjrqFDnh15HEmXrmXcT9fBnNwhrByo",
            "QmPWihwusF9ZwtPiXAf87MWD9cA9gENjjVAHPMtLvDBC12",
            "QmXB34jHAPb7QfRVVnXqpynWaLsGMT1u5a4ZyJWwPRFE7e",
            "QmZPSj78qzByt6UCFcamUtFJV52yhT5zBnWH63drhFDftf",
            "QmVVKjGCh1xjTC9dq3ZUJnZLeJJoQrRJhbT2Jfb52NnsA7",
            "QmauiTLCD6ZBBqZnG1XnkEtgvxfxSAN3YaKtGX9Y4xmNvN",
            "QmVu9UaQ6HzMRSNh4kH3Chn1yr7zXEg3yrfDaAwJKfvynA",
            "QmexUh6jw2ThRr7T8c4DkAhU9QYRzdH8AqAQHxiFrvf9Wi",
            "QmPqpQBWWTb8DP6bmXWgZsXUUh6Lqj2ShMXHC2rudgzzDQ",
            "QmSdPufB8nFjNnexJmkmNva4HrtwNHLDR5LmzkvWA5755d",
            "QmYebUrncSKgvoGXmWo4WyYqnd7B2sE7fgeTj81s8hKann",
            "QmPmFrB8afYZoq2EL3tQ71FiauxkKke5ELDtxNEAXbBe3U",
            "QmQ5NiJuZNoyv6xVm7wZEpvNanqLgajknz1s2EdnEh5YDt",
            "QmaCj77AeNV7F3YE8KTLk6ijXJkqLRZrqoomAcpks1ZpC1",
            "QmUtFQ2NaA1zoBHoASwgaFsn2DED2ZjSR4D3wvt3Y1kTcG",
            "QmZB4qQD4d2uBiSZoUQWpFSRf63FQvkMaSjFzP6CnNgTH1",
            "QmQrm4mw4tYzsNMHd2wvhyqJfZ4u1FosYTr2Fmc9v1KUzt",
            "QmX9ANT6HZGXegt9p5fWRfzv6Bzve2agNGA7LtDzngTJAg",
            "QmczFxFCZEWAsiFCPdsdovKWMqrhAk1zfXM6HS66zFzA4P",
            "QmQDceMyrYftARLBr4QANf4L1Wi4DnCAzrck6JnJ5cKLs2",
            "QmQogFCB14WgPJyoPpmPScRLNynRpGAK9GpbK25Uh9u7pf",
            "QmPGdKY1W7XzCasRyQ6ePyzM2vWjwbHqvUGnZY5BhZus5C",
            "QmaAbvGDB22Ycw7Xn1hapGuYDESvs91jWQdqLGJDiZTLvy",
            "QmbqsPb7SdUbm1TdvgWeh1HytT6ioitJ9mkzKZRsZt1iMU",
            "QmPqpQBWWTb8DP6bmXWgZsXUUh6Lqj2ShMXHC2rudgzzDQ",
            "QmVbZHhThcDrM37P3yge9PyzTVpeuD5EZBzwzqJukuW9CX",
            "QmRruwFh2qGP4vZYsYRgDgScUBzBSWSf61XsrLBi2Y7LZi",
            "QmTjUE74LVF5eUEhSmh4yVSLUwzHdwD1RwhE6MeouXzksn",
            "QmTFS2tozPcH6BApzwhRW1bCVmsLPFFVcMRKHfaTADH87T",
            "QmRgYA3poAMcfDa1qwW9ZbUpy5qSKEk6DYTMwtvStuSM4y",
            "QmZ5eRoQ5qVTAmu41WQkjBemk4yS6nSXJjRDAeG8QmZWjJ",
            "QmcK2YWM3cN7MbcDcL1Wa3uvHhdkeY3gUQjAGfqDpvZSuR",
            "QmX7RSKvKDBKBLJ1zY3ohAwpsCkxp9bwejmKTdE8Lx83eQ",
            "QmWgU93KrKzw7JUBzgt5zmNEfwGrwxud6nS5dZTBPnTcLZ",
            "QmfEpi6bvcaHYgDcvGEBdqavgqvctg8NsVxY6bkfA4d8EE",
            "QmX9ANT6HZGXegt9p5fWRfzv6Bzve2agNGA7LtDzngTJAg",
            "QmPz7X7YwS2HDqTtEa4LqaUQF3geEvmgfQd3LvdaEw6zFH",
            "QmfLa3r4J5DzZ85KzQRbX2sxDLqTcxiTR6gkjp5Chz3KSr",
            "QmYeW9C2zLxoB3imWXLxXKXaRqopWvCbN8WhakAPauE3TK",
            "QmV4CPhqmmyssCqxLU6f6i4jxhaxbkzoiojNkPgZf79Hra",
            "QmP8Ckrb9BvDWXLXoZKoRJvfRhs5U4fS8NaTbEhvvGKzhV",
            "QmcK2YWM3cN7MbcDcL1Wa3uvHhdkeY3gUQjAGfqDpvZSuR",
            "QmTHLruP6iHriHqqw6oPX6Tsy4hiVzT7MQsUpoaubAqsij",
            "QmcCaMjtstUhrv5Utm52NQikLhT4FLu9DWsA6vWTcwSakp",
            "QmYKoXs9hHJy2aZn3dF35BFhmNzr9fz1YhfcgQRs46SynK",
            "QmP8Ckrb9BvDWXLXoZKoRJvfRhs5U4fS8NaTbEhvvGKzhV",
            "QmPqpQBWWTb8DP6bmXWgZsXUUh6Lqj2ShMXHC2rudgzzDQ",
            "QmW1kvaXxDERZcBYyc1ZtzVVTno1iHr5sWGLHPEv6VnRM2",
            "QmYuL7t35d6UZgqeFhXsueFm7V5KQEeyuLcEVgmr11i1Kb",
            "QmP8Ckrb9BvDWXLXoZKoRJvfRhs5U4fS8NaTbEhvvGKzhV",
            "QmZGTsrecqQyNWzh2SSVhsqJsGHwVT2sVEBFcNMnwV73df",
            "QmX9ANT6HZGXegt9p5fWRfzv6Bzve2agNGA7LtDzngTJAg",
            "QmS5Pb4i72JfSsip3PPCELf9Bu3ygce9D2kGS2BEx9PPGy",
            "QmT5J37y58QSqDAJhtfT3NKfh2dxmdgDweBrcpLiedkPEH",
            "QmTRCus34ftngddGLpx3e3gEzWvzoF3NHrK2rc89LNWTyc",
            "QmatWTce4vojinsc5vt7U7woeqYQ87Lhn1NABHx1MYmnNZ",
            "QmeNqqxdMN5AutjZWeqLQFJzfM6Vxvyi9mBHHKyEWv5r31",
            "QmS8q36mainSQneGonX9fFrWB15B7A9HC8o3vkwkCSrqUA",
            "QmWG3mGDQLFuVmajqsiT2nCvmEeU2qgCCCQyG3f4E53svi",
            "QmXMfHnX7MgLcA7Bbj4Bpawe4b5EPg7B1McLaf4XHamq1z",
            "QmS5Pb4i72JfSsip3PPCELf9Bu3ygce9D2kGS2BEx9PPGy",
            "QmQJbKHjvhZtbiaFWJiJ1DxGQ6gyxZxTzKp6VxR95sTXUY",
            "QmV4Bvz7URJa3Rzfp5sBmMQt4FFmWE6Dsuvg6neWpRsEBe",
            "QmX4WEC3Y41mFV4sNNiV6QyTqkRhmu1NnF8ZcQBHZiFVED"
        ];
        string[100] memory tulipURIs = [
            "QmS5Pb4i72JfSsip3PPCELf9Bu3ygce9D2kGS2BEx9PPGy",
            "QmfWRhjNqyXyqEnarRRq5whaBmTm9sKJU7TxWPD39NX4TP",
            "QmX2tgEKCBgRYHPnUAm8AdNFzDJGhjRZ4ZkvQZNmgKUe2p",
            "QmSeAU7SynbUPNPNWeu8wTyV5nJGLSFk1VdequQxbvLggg",
            "QmapgjCNbJmXm1bRNFiQh5ozhMTEBwmhpukpHBiqWFMdDa",
            "QmeYh9ZkRe6ZvdFkRaTjqkdBUF6FwCtEJgAnihXj4j3v13",
            "QmQRk4TozeBtPWnHMtq3Am36LMf33PsJQyzNPTaBWHKNFS",
            "QmUSXJRyhTRxz6TA6MseGqBERXPPid3x8PVkkh99NoFv9S",
            "QmSEwpg5C2dfgxywDeCmtUVaUdKiLFKXQK8d9KCku3SF2Y",
            "QmcQJrWyt1TUjsbjZSjcD4Vz8nKsy4VseJsB8N7EvhSUPJ",
            "QmPb12GN3pcvL78NVQ6FK9AE252ChBK8gQMCzUjez7prC7",
            "QmfGXgopgkAiERmtt2inMuwvaajKv8uUow2WjVuJd8n8Cg",
            "QmRpt7sGKRSxcdpnkdLEdrQZyuMyYgoqez6mYumTdAkmbo",
            "QmSqE8AjqsiHx5baZ2M4p6mjC5Va35F65yDbkRebFaHGZu",
            "QmQ6wZHRCaFHafhyqGAK3638biAk6tz56DCAK2BLQKPTct",
            "QmT8ezQ4nuESWYMzcfbb6kcfESDDyeK2CBYp1uaRQo9xLd",
            "QmZr1z7cCTXRqYWvPSatcGZwJqSt8j6hsMxLUJBQMbnVnr",
            "QmTSuh4gznWdw3STbBVG1Ve1jynHHLpfFcdgFwJi4nqktD",
            "QmRpCGbX5eFbtDehnhatdtp7a1kzmgnkAZSJubsD5Hx7Hh",
            "QmUUDST3T2oHHrf7Sm4AbVxsh46Mt42XyV6S1AMVgFWM88",
            "QmY62Pt1923mPKaJkSLyYoSWCGYbLiyxWQoZYaMHPE8FNF",
            "QmZdDjcsxzS7vQkQiiRmtfDC5S5CAvHRELyMsAF1cPrF3Q",
            "QmQRZ6emrZyepPGSFfGXUAiHJYVRJaKU83Qyr7KcXfNsbf",
            "QmfCDeQvQJ2CwKA5VNie6LC5Ny63VdL7uy7UaZwmoJ5Cmu",
            "QmV585E22k9gJjcBeZNtYdDmoi6yfr36M9yVLdiQP3LxAD",
            "QmeNqqxdMN5AutjZWeqLQFJzfM6Vxvyi9mBHHKyEWv5r31",
            "QmX9ZoDYo5ut3icFft1UugnmkyPbZhuYYpg8yPMJzYFftU",
            "QmRJJLP1ZvPLkyenD7jx7eC798ndeFQyv22rsCaSViLN6k",
            "QmRbt7LFyAAuCMnv9sAhKRtUrUMSrSQYuFPtPNhpSsjgmq",
            "QmQNy8Y83KonKfB59kzhvr9eQ4DjC77mJEjuPUpNRKTiKK",
            "QmZiUEGNKZwQZqrKnDV698hjxT2E4vLuq16Ps3potVDAo8",
            "QmQUxDwfRXyErr8pUcfKaxjCJwUj7SiE9DLrrJHqL9wCxa",
            "QmWrkTnGULvc9m7hUub5ss6H1oTfixfixjdgkbrbvxpKNr",
            "Qmd8eNduEprDi1JX8NUwDXDBDuXcGPmBM3fa1xH5yuMf8d",
            "QmYKXfA6LsVa28Xn2fLz435Smzm4N6FeJ1k3oVhrmvnAJF",
            "Qmf6xbzaQ1P6StboKGApSkuDoXeB5cZ61wotLT5Lz1UR9G",
            "QmZVE4KyoFViMApkgjrqFDnh15HEmXrmXcT9fBnNwhrByo",
            "QmPWihwusF9ZwtPiXAf87MWD9cA9gENjjVAHPMtLvDBC12",
            "QmXB34jHAPb7QfRVVnXqpynWaLsGMT1u5a4ZyJWwPRFE7e",
            "QmZPSj78qzByt6UCFcamUtFJV52yhT5zBnWH63drhFDftf",
            "QmVVKjGCh1xjTC9dq3ZUJnZLeJJoQrRJhbT2Jfb52NnsA7",
            "QmauiTLCD6ZBBqZnG1XnkEtgvxfxSAN3YaKtGX9Y4xmNvN",
            "QmVu9UaQ6HzMRSNh4kH3Chn1yr7zXEg3yrfDaAwJKfvynA",
            "QmexUh6jw2ThRr7T8c4DkAhU9QYRzdH8AqAQHxiFrvf9Wi",
            "QmPqpQBWWTb8DP6bmXWgZsXUUh6Lqj2ShMXHC2rudgzzDQ",
            "QmSdPufB8nFjNnexJmkmNva4HrtwNHLDR5LmzkvWA5755d",
            "QmYebUrncSKgvoGXmWo4WyYqnd7B2sE7fgeTj81s8hKann",
            "QmPmFrB8afYZoq2EL3tQ71FiauxkKke5ELDtxNEAXbBe3U",
            "QmQ5NiJuZNoyv6xVm7wZEpvNanqLgajknz1s2EdnEh5YDt",
            "QmaCj77AeNV7F3YE8KTLk6ijXJkqLRZrqoomAcpks1ZpC1",
            "QmUtFQ2NaA1zoBHoASwgaFsn2DED2ZjSR4D3wvt3Y1kTcG",
            "QmZB4qQD4d2uBiSZoUQWpFSRf63FQvkMaSjFzP6CnNgTH1",
            "QmQrm4mw4tYzsNMHd2wvhyqJfZ4u1FosYTr2Fmc9v1KUzt",
            "QmX9ANT6HZGXegt9p5fWRfzv6Bzve2agNGA7LtDzngTJAg",
            "QmczFxFCZEWAsiFCPdsdovKWMqrhAk1zfXM6HS66zFzA4P",
            "QmQDceMyrYftARLBr4QANf4L1Wi4DnCAzrck6JnJ5cKLs2",
            "QmQogFCB14WgPJyoPpmPScRLNynRpGAK9GpbK25Uh9u7pf",
            "QmPGdKY1W7XzCasRyQ6ePyzM2vWjwbHqvUGnZY5BhZus5C",
            "QmaAbvGDB22Ycw7Xn1hapGuYDESvs91jWQdqLGJDiZTLvy",
            "QmbqsPb7SdUbm1TdvgWeh1HytT6ioitJ9mkzKZRsZt1iMU",
            "QmPqpQBWWTb8DP6bmXWgZsXUUh6Lqj2ShMXHC2rudgzzDQ",
            "QmVbZHhThcDrM37P3yge9PyzTVpeuD5EZBzwzqJukuW9CX",
            "QmRruwFh2qGP4vZYsYRgDgScUBzBSWSf61XsrLBi2Y7LZi",
            "QmTjUE74LVF5eUEhSmh4yVSLUwzHdwD1RwhE6MeouXzksn",
            "QmTFS2tozPcH6BApzwhRW1bCVmsLPFFVcMRKHfaTADH87T",
            "QmRgYA3poAMcfDa1qwW9ZbUpy5qSKEk6DYTMwtvStuSM4y",
            "QmZ5eRoQ5qVTAmu41WQkjBemk4yS6nSXJjRDAeG8QmZWjJ",
            "QmcK2YWM3cN7MbcDcL1Wa3uvHhdkeY3gUQjAGfqDpvZSuR",
            "QmX7RSKvKDBKBLJ1zY3ohAwpsCkxp9bwejmKTdE8Lx83eQ",
            "QmWgU93KrKzw7JUBzgt5zmNEfwGrwxud6nS5dZTBPnTcLZ",
            "QmfEpi6bvcaHYgDcvGEBdqavgqvctg8NsVxY6bkfA4d8EE",
            "QmX9ANT6HZGXegt9p5fWRfzv6Bzve2agNGA7LtDzngTJAg",
            "QmPz7X7YwS2HDqTtEa4LqaUQF3geEvmgfQd3LvdaEw6zFH",
            "QmfLa3r4J5DzZ85KzQRbX2sxDLqTcxiTR6gkjp5Chz3KSr",
            "QmYeW9C2zLxoB3imWXLxXKXaRqopWvCbN8WhakAPauE3TK",
            "QmV4CPhqmmyssCqxLU6f6i4jxhaxbkzoiojNkPgZf79Hra",
            "QmP8Ckrb9BvDWXLXoZKoRJvfRhs5U4fS8NaTbEhvvGKzhV",
            "QmcK2YWM3cN7MbcDcL1Wa3uvHhdkeY3gUQjAGfqDpvZSuR",
            "QmTHLruP6iHriHqqw6oPX6Tsy4hiVzT7MQsUpoaubAqsij",
            "QmcCaMjtstUhrv5Utm52NQikLhT4FLu9DWsA6vWTcwSakp",
            "QmYKoXs9hHJy2aZn3dF35BFhmNzr9fz1YhfcgQRs46SynK",
            "QmP8Ckrb9BvDWXLXoZKoRJvfRhs5U4fS8NaTbEhvvGKzhV",
            "QmPqpQBWWTb8DP6bmXWgZsXUUh6Lqj2ShMXHC2rudgzzDQ",
            "QmW1kvaXxDERZcBYyc1ZtzVVTno1iHr5sWGLHPEv6VnRM2",
            "QmYuL7t35d6UZgqeFhXsueFm7V5KQEeyuLcEVgmr11i1Kb",
            "QmP8Ckrb9BvDWXLXoZKoRJvfRhs5U4fS8NaTbEhvvGKzhV",
            "QmZGTsrecqQyNWzh2SSVhsqJsGHwVT2sVEBFcNMnwV73df",
            "QmX9ANT6HZGXegt9p5fWRfzv6Bzve2agNGA7LtDzngTJAg",
            "QmS5Pb4i72JfSsip3PPCELf9Bu3ygce9D2kGS2BEx9PPGy",
            "QmT5J37y58QSqDAJhtfT3NKfh2dxmdgDweBrcpLiedkPEH",
            "QmTRCus34ftngddGLpx3e3gEzWvzoF3NHrK2rc89LNWTyc",
            "QmatWTce4vojinsc5vt7U7woeqYQ87Lhn1NABHx1MYmnNZ",
            "QmeNqqxdMN5AutjZWeqLQFJzfM6Vxvyi9mBHHKyEWv5r31",
            "QmS8q36mainSQneGonX9fFrWB15B7A9HC8o3vkwkCSrqUA",
            "QmWG3mGDQLFuVmajqsiT2nCvmEeU2qgCCCQyG3f4E53svi",
            "QmXMfHnX7MgLcA7Bbj4Bpawe4b5EPg7B1McLaf4XHamq1z",
            "QmS5Pb4i72JfSsip3PPCELf9Bu3ygce9D2kGS2BEx9PPGy",
            "QmQJbKHjvhZtbiaFWJiJ1DxGQ6gyxZxTzKp6VxR95sTXUY",
            "QmV4Bvz7URJa3Rzfp5sBmMQt4FFmWE6Dsuvg6neWpRsEBe",
            "QmX4WEC3Y41mFV4sNNiV6QyTqkRhmu1NnF8ZcQBHZiFVED"
        ];
        require(ERC721._exists(tokenId), "Enter a tokenId from 0 to 99. Only 100 tulips.");
        if (tokenId == latestNewTulipForSale) {
            return string(abi.encodePacked(_baseURI(), bulbURIs[tokenId]));
        } else {
            return string(abi.encodePacked(_baseURI(), tulipURIs[tokenId]));
        }
    }

    function _beforeTokenTransfer(
        address,
        address,
        uint256 tokenId
    ) internal override {
        // unlist tulip
        tulips[tokenId].listingTime = 0;
        // emit event
        emit TulipNotForSale(tokenId, msg.sender);
    }

    // ETHERROCK

    function getTulipInfo(uint256 tulipNumber)
        public
        view
        returns (
            address owner,
            uint256 listingTime,
            uint256 price,
            uint256 timesSold
        )
    {
        return (
            ERC721.ownerOf(tulipNumber),
            tulips[tulipNumber].listingTime,
            currentPrice(tulipNumber),
            tulips[tulipNumber].timesSold
        );
    }

    function buyTulip(uint256 tulipNumber) public payable {
        // check sellable
        require(tulips[tulipNumber].listingTime != 0);
        // check for sufficient payment
        require(msg.value >= currentPrice(tulipNumber));
        // unlist and update metadata
        tulips[tulipNumber].listingTime = 0;
        tulips[tulipNumber].timesSold++;
        // swap ownership for payment
        if (tulipNumber >= latestNewTulipForSale) {
            // if new, _mint()
            ERC721._mint(msg.sender, latestNewTulipForSale);
            payable(feeRecipient).transfer(msg.value);
            // update auction
            if (latestNewTulipForSale != 99) {
                latestNewTulipForSale++;
                tulips[latestNewTulipForSale].listingTime = block.timestamp;
            }
        } else {
            // if old, _transfer()
            ERC721._transfer(ERC721.ownerOf(tulipNumber), msg.sender, tulipNumber);
            payable(ERC721.ownerOf(tulipNumber)).transfer(msg.value);
        }
        // emit event
        emit TulipSold(tulipNumber, msg.sender, msg.value);
    }

    function sellTulip(uint256 tulipNumber, uint256 price) public {
        require(msg.sender == ERC721.ownerOf(tulipNumber));
        require(price > 0);
        tulips[tulipNumber].price = price;
        tulips[tulipNumber].listingTime = block.timestamp;
        // emit event
        emit TulipForSale(tulipNumber, msg.sender, price);
    }

    function dontSellTulip(uint256 tulipNumber) public {
        require(msg.sender == ERC721.ownerOf(tulipNumber));
        tulips[tulipNumber].listingTime = 0;
        // emit event
        emit TulipNotForSale(tulipNumber, msg.sender);
    }

    function giftTulip(uint256 tulipNumber, address receiver) public {
        ERC721.transferFrom(msg.sender, receiver, tulipNumber);
    }
}
