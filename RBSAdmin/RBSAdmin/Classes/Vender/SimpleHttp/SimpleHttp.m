//
//  SimpleHttp.m
//  SimpleHttp
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

#import "SimpleHttp.h"
#import "AppDelegate.h"

@implementation SimpleHttp
@synthesize error,response,method,fileParams,formParams,request,url;

#pragma mark - class methods

#pragma mark - simple send methods


+(NSData *) sendGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params
{
	SimpleHttp * shttp = [[SimpleHttp alloc] init];
    return [shttp sendGetRequestToURL:aUrl withParameters:params];
}

            
+(void)sendAsyncGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    SimpleHttp * shttp = [[SimpleHttp alloc] init];
    [shttp sendAsyncGetRequestToURL:aUrl withParameters:params andCompletionHandler:handler];
}


+(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params
{
  	SimpleHttp * shttp = [[SimpleHttp alloc] init];
    return [shttp sendPostRequestToURL:aUrl withParameters:params];  
}


+(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    SimpleHttp * shttp = [[SimpleHttp alloc] init];
    [shttp sendAsyncPostRequestToURL:aUrl withParameters:params andCompletionHandler:handler];
}


+(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files
{
    SimpleHttp * shttp = [[SimpleHttp alloc] init];
   return [shttp sendPostRequestToURL:aUrl withParameters:params andFiles:files];
}

+(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    SimpleHttp * shttp = [[SimpleHttp alloc] init];
    [shttp sendAsyncPostRequestToURL:aUrl withParameters:params andFiles:files andCompletionHandler:handler];
}
#pragma mark - instance methods

#pragma mark - lifecycle

-(id)init
{
    self = [super init];
    if(self)
    {
        self.method = @"POST";
    }
    return self;
}

-(void)dealloc
{
    [self setError:nil];
    [self setRequest:nil];
    [self setResponse:nil];
    [self setMethod:nil];
    [self setFileParams:nil];
    [self setFormParams:nil];
    [self setUrl:nil];
}

#pragma mark - simple send methods

/* these methods perform simple GET/POST requests. 
 params is a set of key->value pairs corresponding to the form data you would like to send.
 */

-(NSData *) sendGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params
{
	return [self sendRequest:[self buildGetRequestToURL:aUrl withParameters:params]];   
}


-(void) sendAsyncGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    [self sendAsyncRequest:[self buildGetRequestToURL:aUrl withParameters:params] withCompletionHandler:handler];
}


-(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params
{
    return [self sendRequest:[self buildPostRequestToURL:aUrl withParameters:params]]; 
}


-(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    [self sendAsyncRequest:[self buildPostRequestToURL:aUrl withParameters:params] withCompletionHandler:handler];
}

-(NSData *) sendPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files
{
    return [self sendRequest:[self buildPostRequestToURL:aUrl withParameters:params andFiles:files]];
}


-(void) sendAsyncPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *)files andCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    [self sendAsyncRequest:[self buildPostRequestToURL:aUrl withParameters:params andFiles:files] withCompletionHandler:handler];
}


#pragma mark - more complex request building methods

-(BOOL) addValue:(id)value forQueryParam:(NSString *)param
{
    if(formParams == nil)
    {
        formParams = [NSMutableDictionary dictionary];
    }
    
    [formParams setObject:value forKey:param];
    
    return true;
}

-(BOOL) addFileName:(NSString *)fileName forQueryParam:(NSString *)param
{
    if(fileParams == nil)
    {
        fileParams = [NSMutableDictionary dictionary];
    }
    
    if([[method uppercaseString] isEqual:@"GET"])
    {
        NSLog(@"addFileName error: cannot send file with GET request");
        return false;
    }
    
    [fileParams setObject:fileName forKey:param];
    
    return true;
}

-(NSData *) send
{
    if(fileParams == nil || [[fileParams allKeys] count] == 0)	//no files, just parameters
    {
        if([[method uppercaseString] isEqual:@"POST"])
        {
            return [self sendRequest:[self buildPostRequestToURL:url withParameters:formParams]];
        }
        else if([[method uppercaseString]isEqual:@"GET"])
        {
            return [self sendRequest:[self buildGetRequestToURL:url withParameters:formParams]];
        }
        else 
        {
            NSLog(@"sendRequest error: unknown method: %@", method);
            return nil;
        }
    }
    else 		//files exist
    {
        return [self sendRequest:[self buildPostRequestToURL:url withParameters:formParams andFiles:fileParams]];
    }
}

-(void) sendAsync:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    if(fileParams == nil || [[fileParams allKeys] count] == 0)	//no files, just parameters
    {
        if([[method uppercaseString] isEqual:@"POST"])
        {
            [self sendAsyncRequest:[self buildPostRequestToURL:url withParameters:formParams] withCompletionHandler:handler];
            return;
        }
        else if([[method uppercaseString]isEqual:@"GET"])
        {
            [self sendAsyncRequest:[self buildGetRequestToURL:url withParameters:formParams] withCompletionHandler:handler];
            return;
        }
        else
        {
            NSLog(@"sendRequest error: unknown method: %@", method);
            return;
        }
    }
    else 		//files exist
    {
        [self sendAsyncRequest:[self buildPostRequestToURL:url withParameters:formParams andFiles:fileParams] withCompletionHandler:handler];
        return;
    }
}

#pragma mark - sending requests

/* both send methods set response and error automatically, but it's up to you to catch the data sent back by AsyncRequest */

-(NSData *) sendRequest:(NSURLRequest *) aRequest
{
    NSError * connError;
    NSURLResponse * connResponse;
    NSData * data = [NSURLConnection sendSynchronousRequest:aRequest returningResponse:&connResponse error:&connError];
    response = connResponse;
    error = connError;
    return data;

}

-(void) sendAsyncRequest:(NSURLRequest *) aRequest withCompletionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler
{
    [NSURLConnection sendAsynchronousRequest:aRequest queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *connResponse, NSData *data, NSError *connError) {
                               response = connResponse;
                               error = connError;
                               handler(connResponse, data, connError);
                           }];
}

#pragma  mark - helpers


-(NSMutableURLRequest *) buildPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params andFiles:(NSDictionary *) files
{
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    
    NSMutableData * postData = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [postData appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSMutableData * fileData = [NSMutableData data];

    for(NSString * paramName in [files allKeys])
    {
        NSString * filePath = [files objectForKey:paramName];
        NSString * fileName = [filePath lastPathComponent];
        NSData * currentFile = [[NSData alloc] initWithContentsOfFile:filePath];
        if(!currentFile)
        {
            NSLog(@"Error: error loading file: %@", filePath);
            continue;
        }
        [fileData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", paramName, fileName ] dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileData appendData:currentFile];
        [fileData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    [fileData appendData:postData];
	NSData * allFormData = fileData;
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[allFormData length]];
    
    NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
    [self addLanguageHeader:newRequest];
    
    [newRequest setURL:[NSURL URLWithString:aUrl]];
    [newRequest setHTTPMethod:@"POST"];
    [newRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [newRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    [newRequest setHTTPBody:allFormData];
    
    return newRequest;  
}

-(NSMutableURLRequest *) buildPostRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params
{
    NSString *post = [self getParamStringFromParams:params];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *newRequest = [[NSMutableURLRequest alloc] init];
    [self addLanguageHeader:newRequest];
    
    [newRequest setURL:[NSURL URLWithString:aUrl]];
    [newRequest setHTTPMethod:@"POST"];
    [newRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [newRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [newRequest setHTTPBody:postData];
    return newRequest;
}

-(NSMutableURLRequest *) buildGetRequestToURL:(NSString *)aUrl withParameters:(NSDictionary *)params
{
    
    NSString * finishedUrl = aUrl;
    
    NSString * paramString = [self getParamStringFromParams:params];
    
    if(![paramString isEqual:@""])
    {
    	finishedUrl = [finishedUrl stringByAppendingFormat:@"?%@", paramString];
    }
    
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finishedUrl] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    [self addLanguageHeader:newRequest];
	return  newRequest;
}

- (void)addLanguageHeader:(NSMutableURLRequest *)newRequest {
    /*NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([language rangeOfString:kLMSimplifiedChinese].location == NSNotFound) {
        [newRequest setValue:@"en" forHTTPHeaderField:@"Accept-Language"];
    } else {
        [newRequest setValue:@"zh" forHTTPHeaderField:@"Accept-Language"];
    }*/
    
    [newRequest setValue:@"zh" forHTTPHeaderField:@"Accept-Language"];
}

-(NSString *) getParamStringFromParams:(NSDictionary *)params
{   
    NSString * paramString = @"";
    
    for(NSString * key in [params allKeys])
    {
        paramString = [paramString stringByAppendingFormat:@"&%@=%@", key, [params objectForKey:key]]; 
    }
    
    if (![paramString isEqual:@""])
        paramString = [paramString substringFromIndex:1];	//remove first ampersand
    
    return paramString;
}
@end
