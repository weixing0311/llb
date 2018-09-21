#import "RSAEncrypt.h"

@implementation RSAEncrypt

static SecKeyRef _public_key=nil;

//将openssl生成public_key.der文件转为 string，以方便使用及安全
+ (NSString *)PublicKeyStringFromFile:(NSString *)fileName {
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"der"];
    NSData *publicKeyData = [NSData dataWithContentsOfFile:publicKeyPath];
    
    NSString *publicKeyStr = [publicKeyData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return publicKeyStr;
}

// 从公钥证书文件中获取到公钥的SecKeyRef指针
+ (SecKeyRef)PublicKeyWithString:(NSString *)key{
    if(_public_key == nil){
        NSData *certificateData = [[NSData alloc] initWithBase64EncodedString:key options:NSDataBase64DecodingIgnoreUnknownCharacters];
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

//使用公钥 key 加密字符串，并使用指定的SecPadding
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key secPadding:(SecPadding)padding{
    SecKeyRef keyRef = [self PublicKeyWithString:key];
    size_t cipherBufferSize = SecKeyGetBlockSize(keyRef);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [original dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        NSInteger bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(keyRef,
                                        padding,
                                        (const uint8_t *)[buffer bytes],
                                        [buffer length],
                                        cipherBuffer,
                                        &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    
    return [encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

//使用公钥 key 加密字符串,不使用SecPadding
+ (NSString *) RSAEncrypt:(NSString*)original publicKey:(NSString *)key{
    return [RSAEncrypt RSAEncrypt:original publicKey:key secPadding:kSecPaddingNone];
}

@end
