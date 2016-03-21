//
//  SimpleHttp.h
//  simpleHttp
//
//  Created by Michael on 9/18/12.
//  Copyright (c) 2012 happyMedium
//
//Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface SimpleHttp : NSObject

@property(strong, nonatomic) NSMutableURLRequest *request;
@property(strong, nonatomic) NSError * error;
@property(strong, nonatomic) NSURLResponse * response;

/* attributes used for more complex request building */
@property(strong, nonatomic) NSString * url;
@property(strong, nonatomic) NSString * method;

@property(strong, nonatomic) NSMutableDictionary * formParams;
@property(strong, nonatomic) NSMutableDictionary * fileParams;


#pragma mark - class methods

+(NSData *) sendGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params;
+(void)sendAsyncGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
+(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params;
+(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
+(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files;
+(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

#pragma mark - simple instance methods

-(NSData *) sendGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params;
-(void) sendAsyncGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
-(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params;
-(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;
-(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files;
-(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

#pragma mark - manually building request

-(BOOL) addValue:(id)value forQueryParam:(NSString *)param;
-(BOOL) addFileName:(NSString *)fileName forQueryParam:(NSString *)param;
-(NSData *) send;
-(void) sendAsync:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;


#pragma  mark - sending requests

-(NSData *) sendRequest:(NSURLRequest *) aRequest;
-(void) sendAsyncRequest:(NSURLRequest *) aRequest withCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

#pragma mark - helpers

-(NSMutableURLRequest *) buildPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *) files;
-(NSMutableURLRequest *) buildPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params;
-(NSMutableURLRequest *) buildGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params;
-(NSString *) getParamStringFromParams:(NSDictionary *)params;
@end
