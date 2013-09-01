//
//  NSData_AMDigest.m
//


#import "NSData_AMDigest.h"
//#include <openssl/evp.h>
//#include <openssl/err.h>

#import <CommonCrypto/CommonDigest.h>


@implementation NSData (AMDigest)


- (NSData *)md5Digest
{
	// compute an MD5 digest.
/*	EVP_MD_CTX mdctx;
	unsigned char md_value[EVP_MAX_MD_SIZE];
	unsigned int md_len;
	EVP_DigestInit(&mdctx, EVP_md5());
	EVP_DigestUpdate(&mdctx, [self bytes], [self length]);
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	return [NSData dataWithBytes: md_value length: md_len];*/
    char result[16];
    CC_MD5([self bytes], [self length], result[0]);
    return [NSData dataWithBytes:result length:16];
}


- (NSData *)sha1Digest
{
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([self bytes], [self length], digest);
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
	// compute an SHA1 digest.
/*	EVP_MD_CTX mdctx;
	unsigned char md_value[EVP_MAX_MD_SIZE];
	unsigned int md_len;
	EVP_DigestInit(&mdctx, EVP_sha1());
	EVP_DigestUpdate(&mdctx, [self bytes], [self length]);
	EVP_DigestFinal(&mdctx, md_value, &md_len);
	return [NSData dataWithBytes: md_value length: md_len]; */
}


@end