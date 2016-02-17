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

    func testPrivateKey() {
        let pk =
        "30820c8302010330820c4a06092a864886f70d010701a0820c3b04820c3730820c33308206af06092a864886f70d010706a08206a03082069c020100" +
        "3082069506092a864886f70d010701301c060a2a864886f70d010c0106300e0408c8229c91d7d61fdb0202080080820668ed8968b75a167b4468047e" +
        "998942e9c5d45ac4b368360132ae6c701ba648695fe75fd93c9336c6a4c871beb50d104a9c6e91b16bb49ac21b70f75e796a8d97e7ca9f2d39212315" +
        "a107d30992d4dac2d0cebce78421880be21ba7f63ded491b82f14ad50cd8d20120cf1a6adc4f655533962b1faa894faae93963ef5c4c4e20d0608362" +
        "1208598d55beb8a3e590b65b20c65a8736cea64cf16683d7b7658ece9746c0cbb875a69fd0dfcc43f3b81794542c604647bbc1493819cfbf3422af7d" +
        "aa9289a5d30f197589e32538285c1cfdc073849eea253a504627f8ec7e734d6eddbe30e1e9c084fed4ea3d48df7ef6471f515366be70668ffdce563d" +
        "d89add459ee789cf81ccb64289b34decba19006353060705b4108fedb57c68f140cb01939044e240f710ead41afad14cd883081f37a3a2d41e65fb35" +
        "9e7f89ea2d64d45f152fdb253f60ff583282ac420db6340373775f609a55cad6d6c1cb3294b52e075d32bc7293caefee277ca11e8d3cc5383fe2ab63" +
        "a3c741b19c227215fab30707bbeafd9bc8fbe73c6d0c705843c6b5ec68cd35a8253f659238785c5d80ecbdbf2b2fe9962d8d079a7df73f4c217efdce" +
        "ed1592d8d93a93d57f4150481b4361c889e1bcc3024821d9a04a2530762552ba8c89addeef958bac446e76984ecf7142f9423df095e8400e24bd5b1e" +
        "568994ff0d6bbc187d1b65ff278dc7bf244fea00c35173625eef8a4c745e7f76532ad2dee37a462fe30d2f78b479fab0ee542fb3a55cccae05bf2036" +
        "dcf51c17eec6a45f6ae3f0cd6c98202b9b2eafd4becdff27a5e0616a92d8a5bf86a4b48542b01808f5384d239e180cd82706a73564575dd1e2614554" +
        "961e1dcdbeb28be566df2f546b1e96741f30a1c56f9c4774573006c5c0ff8ea429db612b2e1e9244930c5e70fab14f05415df69960c3bf513b887edd" +
        "0ea1b642dc041f0b70e64d617de618f8e1b119b71e09dc7f831ffbc3c344a1d0cdae9a8f54e1ec996c298df2cd3d9a6d61d97230b85185916d05d0e3" +
        "68cbce3ab43154f6d3d2f2ea1a2f165c55526bc1363d9c1e5138134f7b609b324ba3c982ced69b6fc565bca2bc1675e7aa8b78cad3a474fdafa83682" +
        "f4867a9571c64982b3a31cbac0b995ed0a3252448001fadd4c544ec875d428221b537c0d8369eb9b110f64c5ae3b220c90ed727ffed6b809b2f382a2" +
        "599167bf64f83ae6edfa295de3e3da28b9c1beb5b47889fc9516a36f29c5ac485d0d9dd603a8948d7d606bf8cc48e11ca16070ba3b0e2dad670293f4" +
        "bdde77b4868d5daa86f2c9535638d075e38f7de340caf016ccd9c733c3848b1ad9b30f4944d68429f06bdc61b12c39be099e27ced81246fbd525a08a" +
        "e5fdeb1e569469a5f44907816a09467bddfadd50bc5b835ee1af8dd74216e65425193c1daf27881057975a37dbdbee78c1eb672172b8fc4aa1c754c5" +
        "777e6713e844b296761092809c9334c60790f8249c3dee1acd2af557503eebf0c7c77bd1cab0d51c06a475c57f7d8f0e233a4601bd55a58c9b014339" +
        "57e93221bf70a877e7b28f4f0ecc88b685628c46d0af7bb45a89014234a08196abacea2231c6ce3b774c3e9555aac070bd18203696fa01a2c12f3443" +
        "1697d96b90bec4afbb2c568ac656aede4aa08518077bcaa3373a38b70e489f5d8671c0a6332bf8bfa3dec2bdc00f0e60fa4d9b8f9fb2caa6a559c372" +
        "05803b2be9f0080f1897331317a20fdb1f3c4250005503647db894bba8427e3aee662b2571779fdc8184a77d9a230ac1bd1b2e41205f37ca866d67a0" +
        "9a750b404f9948a3623869ad48fc19bee3d8b0219a967a65be286ee6e256e3150f9afcf70059391ba59e0ae9c1d6b1c687307601552a0aad0aea596c" +
        "54d9e6c14f3f7fd34da6a91bb7fc10ab73ba16ae2c28438a72e30ae5d6655319bb834c265ecf7a09b22ba20afc4370e6c5f4ee97ad846bda54078956" +
        "dc44220de78582e982764f9609fab87a088ea5f43cea5e803432144775b97930bddd560f7ae520ced68bc3fbf6c0e37b34911ed8dfd03481bdca779c" +
        "bced52aa90091b39634e37e08b8f166418cb6b99fc1d56fa20367c31ab8ac91ae72d034422a39fb56059e3d39a6fb5be67fa3f5ce126d34155809013" +
        "74a5db25135869e21d7448a3b359c0d9ace541b1e9e3faa1517c40f31976c77efd2ebd3c7198a403da24751bcc756bf58d7cb6d6aa7352604f8a1b1c" +
        "d3ce77d8d83269e7b7cbbf571a33f31f7839ecaf365c6db417bcc43adb44d8d75beadb8498745c923977f3c4e9eb094be2148a4f4f6bb2b4b2c0f04a" +
        "6062709e1aa5389f673082057c06092a864886f70d010701a082056d048205693082056530820561060b2a864886f70d010c0a0102a08204ee308204" +
        "ea301c060a2a864886f70d010c0103300e040851fe885aceb2be5e02020800048204c8502dd9c1c8e7cf3f5280560d0258bfd926cf7e77fead6fdd6c" +
        "bfec26f97f1b0b4df86c24572ae8486834b1b5bb8246b72ccda54f5392f9c404307f94e988dcefd1425dd3a81d9cc72dc9e36bd5cb1eafd0bda4202d" +
        "fb7c39f5b1c9417da1ee006ad63667247532a1d79a8ce2d95b3428961641760663d152a160eedcd3460aedbea679574159d470d6f43effb9e9588105" +
        "1aa81a6100bc053c618611f1a9639e1fb82466a2bbc545a7123abaae73511ca14fdf38d5d0e75c9116d2dd4c9e7696b7516575a548ff5a77906056db" +
        "b67135f5cd36b870802356b5401f0a44d17c088bc89131103648b9e6a5131b20b2ab5e8107072a04c7bf8be84fb010f12974397e02623d7c2f5dcb22" +
        "f951b293e326ba29c4c4e70042e5a0c5715615467ff713163daac2a41925d50a51e581ada95b6b5140032cf82c115fab3b46db50ec2030113e46e2c5" +
        "da9a76a31bd0e29a0d45f2d0c9a16c921a37d9f3853a8d393a42b3e177232540b5accca1811487312fda932be9ffd656498a41de2caf3587989f9b76" +
        "b85d8fab9838d8df1bc385161187971ea5d6d3728f971d5b668622c2f8a3a4b994043131992a6f0cce7390df895966001eef185b3ffc88b035a92261" +
        "3616b5cb85d97453bca4cad3ee9eb6aa111f91937114c7793a455ecf6b5d39b3bf4e2f2fb2df8f0ca00f177487fce8584ffd9da0d4ad1994a60744f6" +
        "2592cdc3eac1f7ddedbd5e169516ec0848952056bc8f76de16b3c1963544c695da91c6be49fe1988297c0157d659794bc9b1981de769c213960edfc4" +
        "3ed3a866feb8498e9a6d9e4d01a87d188ff17b20e3175924b6673679439c489e50c1eb7bb551c434eff37271324764059368594169247ea2ecfaadfb" +
        "1215ddb4805fdbdc4e939d378e75a2fda0d5d2e2a23998ffbcf5b85ac1b5bf0d0047aed88ef66275d0e5a239f170dd13c53d16a063e2f172c6583acb" +
        "dc88862e28bda67f5e4d9da6785c5206c3e98e83d7adf4d02a3a78112ee2189cc9be5e6e57f8d867868c070ea6d2f623a34322720b92e29bda5a0c7e" +
        "ec5d6b8d7dc62f5090593c15da24d5f8f24fe3660b0079a87c0903d0b9a25057b4c1945525bd1ed0d80c7027b9bfe8a683e7a69972261c169c2171de" +
        "498be8c93208291203a3413366b6193e0657154d1e712b7c7c7e6eae4851b3dae19e0c01014ed292bdbfa33f0bc3cb60717640efdb5c2d000c05543e" +
        "bfbc9a5bc51bc8d9632c8f86f5b07df5a343a6409693788df745a1c832351d4ce26b08b6b2b8044258b5e992593bfd6906e0cd9b6ac99badc4dfff9a" +
        "66eb66d214a04e17e77fa9589e0705c5e5e79bc9be8bc2ec8f6979fccd7731a6f88e8a138b6326426b97e24a7abde50b28ab10eac562ca0f6b98ae29" +
        "35fc06a1a3558fc5810a2d865177b4b8d80a3ad3ae232ae09c58fca6932a659e237c400a90c0902032d3a216563f0b16a4f408efd521bc104a42e6f5" +
        "9efdf1fd37555c088ac5dcb3e7a27c7ee20b2288016b3b3a9a99eb2cfdade0d13eb849cad25813858d16ad46aa839c117f7db57fa4733dac89294b1b" +
        "7db599940d37e5f4d2e3b8ba1aa90cbbb63096de7a13ffe943fe9484bed586670136bf65704d9f5f77788d85f5ff116f5e87bd01681d7b26b7270a1b" +
        "3899d40c61721db28ed27ed21595a2eba6540a9254486aa7c32340a80905978e2424268d341fc2e16c2fa6dc99f3885db45a562219ae96ba9cce0c31" +
        "60303906092a864886f70d010914312c1e2a00500072006f006400200044006900730074002000530065007000740020003200300031003500000000" +
        "302306092a864886f70d0109153116041478268666b64d428ea6178267e53b3d546d75fb2730303021300906052b0e03021a050004143fef9fafc3cf" +
        "795f3ad3e08ba47a9556874e1e21040890382294d112e128020101"
        
        let dd = try! pk.bytesFromHex()
        var items:CFArray?
        let certOptions = [ kSecImportExportPassphrase as String: "skol21" ] as CFDictionary
        let data = NSData(bytes: dd, length: dd.count)

        let status = SecPKCS12Import(data, certOptions, &items);
        if status == errSecSuccess {
            var pkRef: SecKeyRef? = nil
            let arr = items! as [AnyObject]
            let d = arr[0] as? Dictionary<String, AnyObject>
            if (d != nil) {
                let identity = d![kSecImportItemIdentity as String]
                if (identity != nil) {
                    SecIdentityCopyPrivateKey(identity as! SecIdentityRef, &pkRef)
                    XCTAssertNotNil(pkRef)
                }
            }
        }
        
        
        let r = try! Der.parse(dd[dd.startIndex..<dd.endIndex])
        if case let .ARRAY(_, v) = r {
            if case let .ARRAY(_, v1) = v[1] {
                if case let .EXPLICIT(_, v2) = v1[1] {
                    if case let .DATA(_, d1) = v2 {
                        let r1 = try! Der.parse(d1[d1.startIndex..<d1.endIndex])
                        if case let .ARRAY(_,z) = r1 {
                            if case let .ARRAY(_,z1) = z[1] {
                                if case let .EXPLICIT(_,z2) = z1[1] {
                                    if case let .DATA(_,z3) = z2 {
                                        let r2 = try! Der.parse(z3[z3.startIndex..<z3.endIndex])
                                        debugPrint("OK")
                                    }
                                }
                            }
                        }
                        debugPrint("OK")
                    }
                }
            }
        }
        
        
        debugPrint("OK")
    }
    
    func testPublicKey() {
        let pk =
        "3082010a0282010100c7d9a5469a49e9ef3066f5efa449a628e64ed9d63e5a51c71862e8c5a4fd01" +
        "c47a8556b6aaf839caccae18aa1367b9de7ab02ca9e4c5b8ac5c4ef1c2540b818d512bdf10e0cf34" +
        "ca619e4dfcf34abeee328380412494883d78f8fb46efdf00b1ce8806768651b30741fd74417faf17" +
        "034ce7f1182cfd8d8221dcf9fb44072789f2936b1676b925b63f4befece36903a7e6f7d943265110" +
        "197412f2f7f6f4b0642bc19d341526f5d027782a97d3b94b2dd385525fce6ca6c2a599a28b2e7ef2" +
        "515e9666a7d8032f2dcd0fcab58ecbf3c73790c88433b3aad61e8a4f150a077ae695bca79b3cc2dd" +
        "9de93c1c4dd30aaac66925710f78d796aa1cf2123439f189ef0203010001"
        
        let subject = "keepersecurity.com"

        let bytes = try! pk.bytesFromHex()
        let dd = try! DerUtils.publicKeyToCert(bytes, subject:subject)
        let data = NSData(bytes: dd, length: dd.count)
        
        let certRef = SecCertificateCreateWithData(nil, data)
        XCTAssertNotNil(certRef)
        
        let subj = SecCertificateCopySubjectSummary(certRef!)
        XCTAssertNotNil(subj)
        XCTAssertEqual(subject, subj as String)
        
        
        let secPolicy = SecPolicyCreateBasicX509();
        
        var trust:SecTrustRef? = nil
        let _ = SecTrustCreateWithCertificates(certRef!, secPolicy, &trust);
        XCTAssertNotNil(trust)
        let pkk = SecTrustCopyPublicKey(trust!)
        XCTAssertNotNil(pkk)
    }
}
