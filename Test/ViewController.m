//
//  ViewController.m
//  Test
//
//  Created by Sergey Kolupaev on 10/30/15.
//  Copyright © 2015 Sergey Kolupaev. All rights reserved.
//

#import "ViewController.h"
#import "Test-Swift.h"

typedef struct {
    uint16_t      idReserved;   // Reserved
    uint16_t      idType;       // resource type (1 for icons)
    uint16_t      idCount;      // how many images?
    //ICONDIRENTRY        idEntries[1]; // the entries for each image
} ICONDIR;

typedef struct {
    uint8_t bWidth;               // Width of the image
    uint8_t bHeight;              // Height of the image (times 2)
    uint8_t bColorCount;          // Number of colors in image (0 if >=8bpp)
    uint8_t bReserved;            // Reserved
    uint16_t wPlanes;              // Color Planes
    uint16_t wBitCount;            // Bits per pixel
    uint32_t dwBytesInRes;         // how many bytes in this resource?
    uint32_t dwImageOffset;        // where in the file is this image
} ICONDIRENTRY;

typedef struct {
    uint32_t biSize;
    uint32_t  biWidth;
    uint32_t  biHeight;				// Icon Height (added height of XOR-Bitmap and AND-Bitmap)
    uint16_t  biPlanes;
    uint16_t  biBitCount;
    uint32_t biCompression;
    int32_t biSizeImage;
    uint32_t  biXPelsPerMeter;
    uint32_t  biYPelsPerMeter;
    uint32_t biClrUsed;
    uint32_t biClrImportant;
} BITMAPINFOHEADER;

@interface IconDirEntry: NSObject {
@package
    ICONDIRENTRY iconEntry;
    BITMAPINFOHEADER iconHeader;
    
    // COLORS
    uint32_t coSize;
    uint8_t *coData;
    
    // XOR
    uint32_t xorLineSize;
    uint8_t *xorData;
    
    // AND
    uint32_t andLineSize;
    uint8_t *andData;
}
@end
@implementation IconDirEntry
@end


@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource> {
    NSArray<UIImage *> *images;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.field.text = @"www.microsoft.com";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)click:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"https://%@/favicon.ico", self.field.text];
    NSLog(@"URL: %@", urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    [[[NSURLSession sharedSession] dataTaskWithURL:url
                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                    if ([(NSHTTPURLResponse *)response statusCode] == 200) {
                                        if ([data length] > 0) {
                                            images = [self parseIcons: data];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self.picker reloadAllComponents];
                                            });
                                        }
                                    }
                                }] resume];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [images count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%.0f x %.0f", images[row].size.width, images[row].size.height];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.image.image = images[row];
}

uint16_t parseShort(uint8_t *b) {
    uint16_t result = 0;
    for (int i = 0; i < 2; ++i) {
        result += *(b+i) << i;
        
    }
    return result;
}
uint32_t parseLong(uint8_t *b) {
    uint32_t result = 0;
    for (int i = 0; i < 4; ++i) {
        result += *(b+i) << (i*8);
        
    }
    return result;
}

- (NSArray<UIImage *>*)parseIcons: (NSData *)ico_data {
    if ([ico_data length] < 6) {
        NSLog(@"ICONDIR data is too small");
        return nil;
    }
    unsigned char *data = (uint8_t *)ico_data.bytes;
    
    ICONDIR iconDir;
    iconDir.idType = parseShort(data + 2);
    iconDir.idCount = parseShort(data + 4);
    if (iconDir.idType != 1) {
        NSLog(@"Not an ICO");
        return nil;
        
    }

    NSLog(@"Number of icons: %d", iconDir.idCount);
    if ((iconDir.idCount * sizeof(ICONDIRENTRY) + 6) > [ico_data length]) {
        NSLog(@"ICONDIRENTRY array is too small");
        return nil;
    }
    NSMutableArray *im_arr = [[NSMutableArray alloc] init];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < iconDir.idCount; ++i) {
        IconDirEntry *entry = [[IconDirEntry alloc] init];
        [arr addObject:entry];
        
        unsigned char *entry_data = data + 6 + (i * 16);
        entry->iconEntry.bWidth = *entry_data;
        entry->iconEntry.bHeight = *(entry_data + 1);
        entry->iconEntry.bColorCount = *(entry_data + 2);
        entry->iconEntry.wPlanes = parseShort(entry_data + 4);
        entry->iconEntry.wBitCount = parseShort(entry_data + 6);
        entry->iconEntry.dwBytesInRes = parseLong(entry_data + 8);
        entry->iconEntry.dwImageOffset = parseLong(entry_data + 12);
        
        NSLog(@"Icon Size: %dx%d; Color Count: %d; Bit Count: %d; Data Size: %d at Offset %d",
              entry->iconEntry.bWidth, entry->iconEntry.bHeight, entry->iconEntry.bColorCount, entry->iconEntry.wBitCount, entry->iconEntry.dwBytesInRes, entry->iconEntry.dwImageOffset);
        
        if (entry->iconEntry.dwImageOffset + entry->iconEntry.dwBytesInRes > [ico_data length]) {
            NSLog(@"Incorrect format of ICO file");
            return nil;
        }
    }

    NSLog(@"Parsing BITMAPINFOHEADER");
    [arr enumerateObjectsUsingBlock:^(IconDirEntry *entry, NSUInteger idx, BOOL *stop) {
        unsigned char *header_data = data + entry->iconEntry.dwImageOffset;
        entry->iconHeader.biSize = parseLong(header_data);
        if (entry->iconHeader.biSize == sizeof(BITMAPINFOHEADER)) {
            entry->iconHeader.biWidth = parseLong(header_data + 4);
            entry->iconHeader.biHeight = parseLong(header_data + 8);
            entry->iconHeader.biPlanes = parseShort(header_data + 12);
            entry->iconHeader.biBitCount = parseShort(header_data + 14);
            entry->iconHeader.biCompression = parseLong(header_data + 16);
            entry->iconHeader.biSizeImage = parseLong(header_data + 20);
            
            if (entry->iconHeader.biSizeImage == 0) {
                entry->iconHeader.biSizeImage = entry->iconEntry.dwBytesInRes - entry->iconHeader.biSize;
            }
            
            NSLog(@"Bitmap Size: %dx%d; Bit Count: %d",
                  entry->iconHeader.biWidth, entry->iconHeader.biHeight, entry->iconHeader.biBitCount);
            
            if (entry->iconHeader.biCompression == 0) {
                if (entry->iconHeader.biBitCount < 24) {
                    int colors = (entry->iconEntry.bColorCount > 0) ? entry->iconEntry.bColorCount : 256;
                    entry->coSize = colors * 4;
                    entry->coData = header_data + entry->iconHeader.biSize;
                }
                entry->xorData = header_data + entry->iconHeader.biSize + entry->coSize;

                uint32_t sz1 = entry->iconHeader.biWidth * entry->iconHeader.biBitCount;
                uint32_t sz2 = sz1 / 8;  // adjust to byte
                sz1 = (sz2*8 < sz1) ? sz2+1 : sz2;
                sz2 = sz1 / 4; // adjust to 32 bit 4bytes
                
                entry->xorLineSize = (sz2*4 < sz1) ? (sz2+1)*4 : sz1;
                
                if (entry->iconHeader.biBitCount < 32 && entry->iconHeader.biHeight > entry->iconEntry.bHeight) {
                    entry->andData = entry->xorData + (entry->xorLineSize * entry->iconEntry.bHeight);
                    sz1 = entry->iconHeader.biWidth;
                    sz2 = sz1 / 8;  // adjust to byte
                    sz1 = (sz2*8 < sz1) ? sz2+1 : sz2;
                    sz2 = sz1 / 4; // adjust to 32 bit 4bytes
                    
                    entry->andLineSize = (sz2*4 < sz1) ? (sz2+1)*4 : sz1;
                }

                NSLog(@"XOR Line size: %d", entry->xorLineSize);
                if (entry->andLineSize > 0) {
                    NSLog(@"AND Line size: %d", entry->andLineSize);
                }
                
                if ((entry->xorLineSize + entry->andLineSize) * entry->iconHeader.biWidth <= entry->iconHeader.biSizeImage) {
                    uint8_t *image_data = malloc(entry->iconEntry.bWidth * entry->iconEntry.bHeight * 4);
                    memset(image_data, 0, entry->iconEntry.bWidth * entry->iconEntry.bHeight * 4);
                    for (int y = 0; y < entry->iconEntry.bHeight; ++y) {
                        uint8_t *xor_data = entry->xorData + ((entry->iconEntry.bHeight - 1 - y) * entry->xorLineSize);
                        for (int x = 0; x < entry->iconEntry.bWidth; ++x) {
                            uint8_t *pixel_ptr = image_data + ((x + (y * entry->iconEntry.bHeight)) * 4);
                            switch(entry->iconHeader.biBitCount) {
                                case 1: // color map monochrome
                                case 4: // color map 16 colors
                                case 8: // color map 256 colors
                                {
                                    int color_idx = -1;
                                    switch (entry->iconHeader.biBitCount) {
                                        case 1: // color map monochrome
                                            color_idx = (xor_data[x/8] & 1<<(7-x%8)) > 0 ? 1 : 0;
                                            break;
                                        case 4: // color map 16 colors
                                            color_idx = xor_data[x/2];
                                            if (x%2 == 0) {
                                                color_idx = color_idx >> 4;
                                            }
                                            color_idx &= 0x0f;
                                            break;
                                        case 8: // color map 256 colors
                                            color_idx = pixel_ptr[x];
                                            break;
                                    }
                                    int color_num = entry->iconEntry.bColorCount > 0 ? entry->iconEntry.bColorCount : 256;
                                    if (color_idx < color_num) {
                                        uint8_t *color_ptr = entry->coData + (color_idx * 4);
                                        *(pixel_ptr) = *(color_ptr + 2);
                                        *(pixel_ptr + 1) = *(color_ptr + 1);
                                        *(pixel_ptr + 2) = *(color_ptr + 0);
                                        *(pixel_ptr + 3) = 0xff;
                                       //NSLog(@"%d:%d: Index: %d Color(%d,%d,%d)", y, x, color_idx, *(pixel_ptr), *(pixel_ptr+1), *(pixel_ptr+2));
                                    } else {
                                        NSLog(@"Color index is out of bounds");
                                    }
                                }
                                    break;
                                case 24: // no color map r g b
                                {
                                    uint8_t *ptr = xor_data + (x * 3);
                                    *(pixel_ptr) = *(ptr + 2);
                                    *(pixel_ptr + 1) = *(ptr + 1);
                                    *(pixel_ptr + 2) = *(ptr + 0);
                                    *(pixel_ptr + 3) = 0xff;
                                }
                                    break;
                                case 32: // no color map r g b a
                                {
                                    uint8_t *ptr = xor_data + (x * 4);
                                    *(pixel_ptr) = *(ptr + 2);
                                    *(pixel_ptr + 1) = *(ptr + 1);
                                    *(pixel_ptr + 2) = *(ptr + 0);
                                    *(pixel_ptr + 3) = *(ptr + 3);
                                }
                                    break;
                            }
                            if (entry->andLineSize > 0) {
                                uint8_t *and_data = entry->andData + ((entry->iconEntry.bHeight - 1 - y) * entry->andLineSize);
                                if ((and_data[x/8] & 1<<(7-x%8)) != 0) {
                                    *(pixel_ptr + 3) = 0x00;
                                }
                            }
                        }
                        
                    }
                    
                    NSMutableData *rr = [NSMutableData dataWithBytes:image_data length:entry->iconEntry.bWidth * entry->iconEntry.bHeight * 4];
                    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                    CGContextRef context = CGBitmapContextCreate(image_data, entry->iconEntry.bWidth, entry->iconEntry.bHeight,
                                          8, entry->iconEntry.bWidth * 4, colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault);
                    CGImageRef image_ref = CGBitmapContextCreateImage(context);
                    UIImage *image = [UIImage imageWithCGImage:image_ref];
                    CGImageRelease(image_ref);
                    CGColorSpaceRelease(colorSpace);
                    CGContextRelease(context);
                    
                    [im_arr addObject:image];

                    free(image_data);
                    
                } else {
                    NSLog(@"Incorrect image size");
                }
                
            } else {
                NSLog(@"Compressed PNG image");
            }
        } else {
            NSLog(@"Unsupported icon header format");
        }
    }];
    
    return im_arr;
}
/*

 typedef struct
 {
	unsigned short      idReserved;   // Reserved
	unsigned short      idType;       // resource type (1 for icons)
	unsigned short      idCount;      // how many images?
	//ICONDIRENTRY  idEntries[1]; // the entries for each image
 } ICONDIR, *LPICONDIR;
 
 typedef struct
 {
	unsigned char bWidth;               // Width of the image
	unsigned char bHeight;              // Height of the image (times 2)
	unsigned char bColorCount;          // Number of colors in image (0 if >=8bpp)
	unsigned char bReserved;            // Reserved
	unsigned short wPlanes;              // Color Planes
	unsigned short wBitCount;            // Bits per pixel
	unsigned long dwBytesInRes;         // how many bytes in this resource?
	unsigned long dwImageOffset;        // where in the file is this image
 } ICONDIRENTRY, *LPICONDIRENTRY;
 
 
 // size - 40 bytes
 typedef struct {
	unsigned long biSize;
	unsigned long  biWidth;
	unsigned long  biHeight;				// Icon Height (added height of XOR-Bitmap and AND-Bitmap)
	unsigned short  biPlanes;
	unsigned short  biBitCount;
	unsigned long biCompression;
	long biSizeImage;
	unsigned long  biXPelsPerMeter;
	unsigned long  biYPelsPerMeter;
	unsigned long biClrUsed;
	unsigned long biClrImportant;
 } BITMAPINFOHEADER, *PBITMAPINFOHEADER;
 
 // 46 bytes
 typedef struct{
 BITMAPINFOHEADER   icHeader;      		// DIB header
 unsigned long		icColors[1];   		// Color table (short 4 bytes) //RGBQUAD
 unsigned char      icXOR[1];      // DIB bits for XOR mask
 unsigned char      icAND[1];      // DIB bits for AND mask
 } ICONIMAGE, *LPICONIMAGE;
 

 */
@end
