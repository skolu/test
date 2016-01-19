//
//  DerTest.swift
//  Test
//
//  Created by Sergey Kolupaev on 1/14/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

import XCTest

class DerTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        let pk:String =
        "3082010a0282010100c7d9a5469a49e9ef3066f5efa449a628e64ed9d63e5a51c71862e8c5a4fd01" +
        "c47a8556b6aaf839caccae18aa1367b9de7ab02ca9e4c5b8ac5c4ef1c2540b818d512bdf10e0cf34" +
        "ca619e4dfcf34abeee328380412494883d78f8fb46efdf00b1ce8806768651b30741fd74417faf17" +
        "034ce7f1182cfd8d8221dcf9fb44072789f2936b1676b925b63f4befece36903a7e6f7d943265110" +
        "197412f2f7f6f4b0642bc19d341526f5d027782a97d3b94b2dd385525fce6ca6c2a599a28b2e7ef2" +
        "515e9666a7d8032f2dcd0fcab58ecbf3c73790c88433b3aad61e8a4f150a077ae695bca79b3cc2dd" +
        "9de93c1c4dd30aaac66925710f78d796aa1cf2123439f189ef0203010001"
        
        let cert = "3082055f30820447a0030201020209008ecec56ad0b10a61300d06092a86" +
        "4886f70d01010b05003081c6310b30090603550406130255533110300e06" +
        "0355040813074172697a6f6e61311330110603550407130a53636f747473" +
        "64616c6531253023060355040a131c537461726669656c6420546563686e" +
        "6f6c6f676965732c20496e632e31333031060355040b132a687474703a2f" +
        "2f63657274732e737461726669656c64746563682e636f6d2f7265706f73" +
        "69746f72792f313430320603550403132b537461726669656c6420536563" +
        "75726520436572746966696361746520417574686f72697479202d204732" +
        "301e170d3135313230393138353633385a170d3137313231333137353730" +
        "315a303f3121301f060355040b1318446f6d61696e20436f6e74726f6c20" +
        "56616c696461746564311a3018060355040313116465762e6b6565706572" +
        "6170702e636f6d30820122300d06092a864886f70d01010105000382010f" +
        "003082010a0282010100cb4c330b6ba513ccc41f5c13ba9f6177c3112385" +
        "7d39895c8f52a3a9af4a71bab3bd8ebb7501609d8582b18df8787eb6b338" +
        "a6e19e00d2b007a4e86012703e031fb15d5b4c9b7086d08ef7c0d41c6428" +
        "c69d09fda3c23b70576c5c4cb0c10e1dace3ade0268ca048b42537d464a5" +
        "17efbf0a65d83c51b1ef88d1611820ff92d8174aca0e0fcb20945d23ef50" +
        "e22f9f5a0e5639e88620dece54c90bf01e9d4819ec01adce75ba3582c31d" +
        "6288b1f9b1da9f9331a6b2dfa4ca4e5e475209eafaf8240ee2c24a200eb8" +
        "24fa894c7dd201489d3dfc68c3720a6fbc62ad26c24eb184aa56757c3cde" +
        "7b5154da9b782b3a0c575836c6227710ec4abadb3ec7fa53044102030100" +
        "01a38201d4308201d0300c0603551d130101ff04023000301d0603551d25" +
        "0416301406082b0601050507030106082b06010505070302300e0603551d" +
        "0f0101ff0404030205a0303c0603551d1f043530333031a02fa02d862b68" +
        "7474703a2f2f63726c2e737461726669656c64746563682e636f6d2f7366" +
        "69673273312d32302e63726c30590603551d2004523050304e060b608648" +
        "0186fd6e01071701303f303d06082b060105050702011631687474703a2f" +
        "2f6365727469666963617465732e737461726669656c64746563682e636f" +
        "6d2f7265706f7369746f72792f30818206082b0601050507010104763074" +
        "302a06082b06010505073001861e687474703a2f2f6f6373702e73746172" +
        "6669656c64746563682e636f6d2f304606082b06010505073002863a6874" +
        "74703a2f2f6365727469666963617465732e737461726669656c64746563" +
        "682e636f6d2f7265706f7369746f72792f73666967322e637274301f0603" +
        "551d23041830168014254581685026383d3b2d2cbecd6ad9b63db3666330" +
        "330603551d11042c302a82116465762e6b65657065726170702e636f6d82" +
        "157777772e6465762e6b65657065726170702e636f6d301d0603551d0e04" +
        "16041481cf1c6eef10a19220ef4606befd7518abb4d7dc300d06092a8648" +
        "86f70d01010b050003820101002989082a9ce816ffad311c3e154a038948" +
        "e570c1a7672aedb404239c239d87f0aa100f8373de4e5871d445a8f030aa" +
        "0d3ee35cb7476fe8255259977cc2b452b3c28b2d90db34154cb545c22d7d" +
        "8cc2577af372057a8ce42bfe4f8353030f8e50d0acd1891d2e409e103f37" +
        "4cab94fb5e418e8fabc816a10c9abb46a018ae7688beac035ff7996d3c07" +
        "310f60b727c147057134edcc779fc2ed44ef5e434e12605d584d3bc63491" +
        "f55015755ce737464d38bad84014a11bd02e95be5ccf6606b798f8303479" +
        "42081a237a3eb2d58776668e11d36d4112a07e71b7fac00d2cef630d878b" +
        "caa7147b6fac89bc299046e5b14c5714b8a2e562d271bae5ffd5882260"

/*
        Certificate  ::=  SEQUENCE  {
        tbsCertificate       TBSCertificate,
        signatureAlgorithm   AlgorithmIdentifier,
        signatureValue       BIT STRING
        }
        
        TBSCertificate  ::=  SEQUENCE  {
        version         [0]  EXPLICIT Version DEFAULT v1,
        serialNumber         CertificateSerialNumber,
        signature            AlgorithmIdentifier,
        issuer               Name,
        validity             Validity,
        subject              Name,
        subjectPublicKeyInfo SubjectPublicKeyInfo,
        issuerUniqueID  [1]  IMPLICIT UniqueIdentifier OPTIONAL,
        -- If present, version MUST be v2 or v3
        subjectUniqueID [2]  IMPLICIT UniqueIdentifier OPTIONAL,
        -- If present, version MUST be v2 or v3
        extensions      [3]  EXPLICIT Extensions OPTIONAL
        -- If present, version MUST be v3
        }
        
        Version  ::=  INTEGER  {  v1(0), v2(1), v3(2)  }
        
        CertificateSerialNumber  ::=  INTEGER
        
        Validity ::= SEQUENCE {
        notBefore      Time,
        notAfter       Time
        }
        
        Time ::= CHOICE {
        utcTime        UTCTime,
        generalTime    GeneralizedTime
        }
        
        UniqueIdentifier  ::=  BIT STRING
        
        SubjectPublicKeyInfo  ::=  SEQUENCE  {
        algorithm            AlgorithmIdentifier,
        subjectPublicKey     BIT STRING
        }
        
        AlgorithmIdentifier  ::=  SEQUENCE  {
        algorithm               OBJECT IDENTIFIER,
        parameters              ANY DEFINED BY algorithm OPTIONAL
        }
        
        Extensions  ::=  SEQUENCE SIZE (1..MAX) OF Extension
        
        Extension  ::=  SEQUENCE  {
        extnID      OBJECT IDENTIFIER,
        critical    BOOLEAN DEFAULT FALSE,
        extnValue   OCTET STRING
        -- contains the DER encoding of an ASN.1 value
        -- corresponding to the extension type identified
        -- by extnID
        }
        
        Name ::= CHOICE { -- only one possibility for now --
        rdnSequence  RDNSequence
        }
        
        RDNSequence ::= SEQUENCE OF RelativeDistinguishedName
        
        RelativeDistinguishedName ::=
        SET SIZE (1..MAX) OF AttributeTypeAndValue
        
        AttributeTypeAndValue ::= SEQUENCE {
        type     AttributeType,
        value    AttributeValue }
        
        AttributeType ::= OBJECT IDENTIFIER
        
        AttributeValue ::= ANY -- DEFINED BY AttributeType
        */
        
        //let aa = try! cert.bytesFromHex()
        //print(try! Der.parse(aa[aa.startIndex..<aa.endIndex]))
        
        
        var cert_fields = [DerNode]()
        cert_fields.append(DerNode.EXPLICIT(number: 0, value: DerNode.DATA(type: .Integer, value: [1])))
        cert_fields.append(DerNode.DATA(type: .Integer, value: try! "0000000000000000".bytesFromHex()))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.OBJECT_IDENTIFIER(value: [1,2,840,113549,1,1,11]), DerNode.NULL()]))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: []))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.TIME(type: .UTCTime, value: NSDate()), DerNode.TIME(type: .UTCTime, value: NSDate())]))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.ARRAY(type: .Set, value: [
                DerNode.ARRAY(type: .Sequence, value: [
                    DerNode.OBJECT_IDENTIFIER(value: [2,5,4,3]),
                    DerNode.STRING(type: .PrintableString, value: "dev.keepersecurity.com")])])]))
        
        
        
        var bytes = try! pk.bytesFromHex()
        if bytes[bytes.startIndex] >= 0x80 {
            bytes.insert(0, atIndex: bytes.startIndex)
        }
        bytes.insert(0, atIndex: bytes.startIndex)
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.ARRAY(type: .Sequence, value: [DerNode.OBJECT_IDENTIFIER(value: [1,2,840,113549,1,1,1]), DerNode.NULL()]),
            DerNode.DATA(type: .BitString, value: bytes)]))

        let certificate = DerNode.ARRAY(type: .Sequence, value: [
            DerNode.ARRAY(type: .Sequence, value: cert_fields),
            DerNode.ARRAY(type: .Sequence, value: [
                DerNode.OBJECT_IDENTIFIER(value: [1,2,840,113549,1,1,11]), DerNode.NULL()]),
            DerNode.DATA(type: .BitString, value: [00])
            ])

        print(certificate)

        let dd = try! Der.serialize(certificate)
        let data = NSData(bytes: dd, length: dd.count)
        
        let certRef = SecCertificateCreateWithData(nil, data)
        let subj = SecCertificateCopySubjectSummary(certRef!)
        let secPolicy = SecPolicyCreateBasicX509();
        
        var trust:SecTrustRef? = nil
        let statusTrust = SecTrustCreateWithCertificates(certRef!, secPolicy, &trust);
        let pkk = SecTrustCopyPublicKey(trust!)
        XCTAssertNotNil(pkk)
    }
}
