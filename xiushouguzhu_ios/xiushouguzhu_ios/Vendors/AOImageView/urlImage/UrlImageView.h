//
//  UrlImageButton.h
//  test image
//
//  Created by Xuyan Yang on 8/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UrlImageView : UIImageView {	
	NSInteger iconIndex;

	CGSize scaleSize;
	BOOL    isScale;

	BOOL    _animated;
}
@property (nonatomic, assign) BOOL    _animated;
@property (nonatomic, assign) NSInteger iconIndex;

- (void) setImageFromUrl:(BOOL) animated withUrl:(NSString *)iconUrl;

- (void)setImageWithURL:(NSURL *)url;


-(void)scaleToSize:(CGSize)size ;
@end
