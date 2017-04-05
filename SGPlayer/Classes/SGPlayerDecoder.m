//
//  SGPlayerDecoder.m
//  SGPlayer
//
//  Created by Single on 03/01/2017.
//  Copyright © 2017 single. All rights reserved.
//

#import "SGPlayerDecoder.h"

@interface SGPlayerDecoder ()

@property (nonatomic, strong) NSMutableDictionary * formatContextOptions;

@end

@implementation SGPlayerDecoder

+ (instancetype)decoderByDefault
{
    SGPlayerDecoder * decoder = [[self alloc] init];
    decoder.decodeTypeForUnknown   = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForMP3       = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForMPEG4     = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForFLV       = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForM3U8      = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForRTMP      = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForRTSP      = SGDecoderTypeFFmpeg;
    return decoder;
}

+ (instancetype)decoderByAVPlayer
{
    SGPlayerDecoder * decoder = [[self alloc] init];
    decoder.decodeTypeForUnknown   = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForMP3       = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForMPEG4     = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForFLV       = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForM3U8      = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForRTMP      = SGDecoderTypeAVPlayer;
    decoder.decodeTypeForRTSP      = SGDecoderTypeAVPlayer;
    return decoder;
}

+ (instancetype)decoderByFFmpeg
{
    SGPlayerDecoder * decoder = [[self alloc] init];
    decoder.decodeTypeForUnknown   = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForMP3       = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForMPEG4     = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForFLV       = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForM3U8      = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForRTMP      = SGDecoderTypeFFmpeg;
    decoder.decodeTypeForRTSP      = SGDecoderTypeFFmpeg;
    return decoder;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.hardwareAccelerateEnableForFFmpeg = YES;
        self.formatContextOptions = [NSMutableDictionary dictionary];
        [self setFFmpegFormatContextOptionStringValue:@"SGPlayer" forKey:@"user-agent"];
    }
    return self;
}

- (NSDictionary *)FFmpegFormatContextOptions
{
    return [self.formatContextOptions copy];
}

- (void)setFFmpegFormatContextOptionIntValue:(int64_t)value forKey:(NSString *)key
{
    [self.formatContextOptions setValue:@(value) forKey:key];
}

- (void)setFFmpegFormatContextOptionStringValue:(NSString *)value forKey:(NSString *)key
{
    [self.formatContextOptions setValue:value forKey:key];
}

- (void)removeFFmpegFormatContextOptionForKey:(NSString *)key
{
    [self.formatContextOptions removeObjectForKey:key];
}

- (SGMediaFormat)mediaFormatForContentURL:(NSURL *)contentURL
{
    if (!contentURL) return SGMediaFormatError;
    
    NSString * path;
    if (contentURL.isFileURL) {
        path = contentURL.path;
    } else {
        path = contentURL.absoluteString;
    }
    path = [path lowercaseString];
    
    if ([path hasPrefix:@"rtmp:"])
    {
        return SGMediaFormatRTMP;
    }
    else if ([path hasPrefix:@"rtsp:"])
    {
        return SGMediaFormatRTSP;
    }
    else if ([path containsString:@".flv"])
    {
        return SGMediaFormatFLV;
    }
    else if ([path containsString:@".mp4"])
    {
        return SGMediaFormatMPEG4;
    }
    else if ([path containsString:@".mp3"])
    {
        return SGMediaFormatMP3;
    }
    else if ([path containsString:@".m3u8"])
    {
        return SGMediaFormatM3U8;
    }
    return SGMediaFormatUnknown;
}

- (SGDecoderType)decoderTypeForContentURL:(NSURL *)contentURL
{
    SGMediaFormat mediaFormat = [self mediaFormatForContentURL:contentURL];
    switch (mediaFormat) {
        case SGMediaFormatError:
            return SGDecoderTypeError;
        case SGMediaFormatUnknown:
            return self.decodeTypeForUnknown;
        case SGMediaFormatMP3:
            return self.decodeTypeForMP3;
        case SGMediaFormatMPEG4:
            return self.decodeTypeForMPEG4;
        case SGMediaFormatFLV:
            return self.decodeTypeForFLV;
        case SGMediaFormatM3U8:
            return self.decodeTypeForM3U8;
        case SGMediaFormatRTMP:
            return self.decodeTypeForRTMP;
        case SGMediaFormatRTSP:
            return self.decodeTypeForRTSP;
    }
}

@end
