//
//  CHIPQRCodeSetupPayloadParser.m
//  CHIPQRCodeReader
/**
*
*    Copyright (c) 2020 Project CHIP Authors
*
*    Licensed under the Apache License, Version 2.0 (the "License");
*    you may not use this file except in compliance with the License.
*    You may obtain a copy of the License at
*
*        http://www.apache.org/licenses/LICENSE-2.0
*
*    Unless required by applicable law or agreed to in writing, software
*    distributed under the License is distributed on an "AS IS" BASIS,
*    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*    See the License for the specific language governing permissions and
*    limitations under the License.
*/

#import "CHIPQRCodeSetupPayloadParser.h"
#import "CHIPError.h"

#import <setup_payload/QRCodeSetupPayloadParser.h>
#import <setup_payload/SetupPayload.h>

@implementation CHIPQRCodeSetupPayloadParser {
    NSString *_base45Representation;
    chip::QRCodeSetupPayloadParser *_chipQRCodeSetupPayloadParser;
}

- (id)initWithBase45Representation:(NSString *)base45Representation
{
    if(self = [super init]) {
        _base45Representation = base45Representation;
        _chipQRCodeSetupPayloadParser = new chip::QRCodeSetupPayloadParser(std::string([base45Representation UTF8String]));
    }
    return self;
}

- (CHIPSetupPayload *)populatePayload:(NSError *__autoreleasing *)error
{
    chip::SetupPayload cPlusPluspayload;
    CHIP_ERROR chipError = _chipQRCodeSetupPayloadParser->populatePayload(cPlusPluspayload);

    CHIPSetupPayload *payload;
    if (chipError == 0) {
        payload = [[CHIPSetupPayload alloc] initWithSetupPayload:cPlusPluspayload];
    } else if (error) {
         *error = [CHIPError errorForCHIPErrorCode:chipError];
    }
    return payload;
}
@end
