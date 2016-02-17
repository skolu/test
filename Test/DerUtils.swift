//
//  DerUtils.swift
//  Test
//
//  Created by Sergey Kolupaev on 2/16/16.
//  Copyright © 2016 Sergey Kolupaev. All rights reserved.
//

import Foundation

struct DerUtils {
    static func publicKeyToCert(publicKey:[UInt8], subject:String) throws -> [UInt8] {
        var cert_fields = [DerNode]()
        cert_fields.append(DerNode.EXPLICIT(number: 0, value: DerNode.DATA(type: .Integer, value: [1])))
        cert_fields.append(DerNode.DATA(type: .Integer, value: [0,0,0,0,0,0,0,0,0]))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.OBJECT_IDENTIFIER(value: [1,2,840,113549,1,1,11]), DerNode.NULL()]))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: []))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.TIME(type: .UTCTime, value: NSDate()), DerNode.TIME(type: .UTCTime, value: NSDate())]))
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.ARRAY(type: .Set, value: [
                DerNode.ARRAY(type: .Sequence, value: [
                    DerNode.OBJECT_IDENTIFIER(value: [2,5,4,3]),
                    DerNode.STRING(type: .PrintableString, value: subject)])])]))
        
        var key = [UInt8](publicKey)
        if key[key.startIndex] >= 0x80 {
            key.insert(0, atIndex: key.startIndex)
        }
        key.insert(0, atIndex: key.startIndex)
        cert_fields.append(DerNode.ARRAY(type: .Sequence, value: [
            DerNode.ARRAY(type: .Sequence, value: [DerNode.OBJECT_IDENTIFIER(value: [1,2,840,113549,1,1,1]), DerNode.NULL()]),
            DerNode.DATA(type: .BitString, value: key)]))
        
        let certificate = DerNode.ARRAY(type: .Sequence, value: [
            DerNode.ARRAY(type: .Sequence, value: cert_fields),
            DerNode.ARRAY(type: .Sequence, value: [
                DerNode.OBJECT_IDENTIFIER(value: [1,2,840,113549,1,1,11]), DerNode.NULL()]),
            DerNode.DATA(type: .BitString, value: [00])
            ])
        
        return try Der.serialize(certificate)
    }
}

/*
PFX ::= SEQUENCE {
    version     INTEGER {v3(3)}(v3,...),
    authSafe    ContentInfo,
    macData     MacData OPTIONAL
}

ContentInfo, DigestInfo
    FROM PKCS-7 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-7(7) modules(0) pkcs-7(1)}

SafeBag ::= SEQUENCE {
    bagId         BAG-TYPE.&id ({PKCS12BagSet}),
    bagValue      [0] EXPLICIT BAG-TYPE.&Type({PKCS12BagSet}{@bagId}),
    bagAttributes SET OF PKCS12Attribute OPTIONAL
}

-- ============================
-- Bag types
-- ============================

keyBag BAG-TYPE ::=  
{KeyBag             IDENTIFIED BY {bagtypes 1}}

pkcs8ShroudedKeyBag BAG-TYPE ::=
{PKCS8ShroudedKeyBag IDENTIFIED BY {bagtypes 2}}

certBag BAG-TYPE ::=
{CertBag             IDENTIFIED BY {bagtypes 3}}

crlBag BAG-TYPE ::=
{CRLBag              IDENTIFIED BY {bagtypes 4}}

secretBag BAG-TYPE ::=
{SecretBag           IDENTIFIED BY {bagtypes 5}}

safeContentsBag BAG-TYPE ::=
{SafeContents        IDENTIFIED BY {bagtypes 6}}

KeyBag ::= PrivateKeyInfo

PrivateKeyInfo, EncryptedPrivateKeyInfo
    FROM PKCS-8 {iso(1) member-body(2) us(840) rsadsi(113549) pkcs(1) pkcs-8(8) modules(1) pkcs-8(1)}


*/


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
    issuerUniqueID  [1]  IMPLICIT UniqueIdentifier OPTIONAL,  -- If present, version MUST be v2 or v3
    subjectUniqueID [2]  IMPLICIT UniqueIdentifier OPTIONAL,  -- If present, version MUST be v2 or v3
    extensions      [3]  EXPLICIT Extensions OPTIONAL         -- If present, version MUST be v3
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
    extnValue   OCTET STRING    -- contains the DER encoding of an ASN.1 value
                                -- corresponding to the extension type identified by extnID
}

Name ::= CHOICE { -- only one possibility for now --
    rdnSequence  RDNSequence
}

RDNSequence ::= SEQUENCE OF RelativeDistinguishedName

RelativeDistinguishedName ::= SET SIZE (1..MAX) OF AttributeTypeAndValue

AttributeTypeAndValue ::= SEQUENCE {
    type     AttributeType,
    value    AttributeValue 
}

AttributeType ::= OBJECT IDENTIFIER

AttributeValue ::= ANY -- DEFINED BY AttributeType
*/
