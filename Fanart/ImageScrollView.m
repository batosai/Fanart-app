

#import "ImageScrollView.h"
#import "FanartAppDelegate.h"

@implementation ImageScrollView

@synthesize index, navigationBarController;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.maximumZoomScale = 2;
        self.minimumZoomScale = 1;
        //self.zoomScale = .37;
        //self.decelerationRate = UIScrollViewDecelerationRateFast;
        //self.clipsToBounds = YES;
        //self.bounces = NO;//interdit les rebonds
        self.delegate = self;
        
        self.backgroundColor = [UIColor clearColor];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

        CGRect frame = indicatorView.frame;
        frame.origin.x = (self.frame.size.width/2) - (frame.size.width/2);
        frame.origin.y = (self.frame.size.height/2) - (frame.size.height/2);
        indicatorView.frame = frame;

        [self addSubview:indicatorView];
        [indicatorView startAnimating];
    }

    return self;
}

- (void)dealloc
{
    [indicatorView release];
    [imageView release];
    //[navigationBarController release]; /!\ il s'agit d'un pointeur, si on le release il n'y as plus d'espace alouer, or nous en avons tjr besoin dans les autres images.
    [super dealloc];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

//charge l'image et centre l'image pendant le zoom.
- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
  
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
}

- (void)loadImage:(NSString *)string
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:string forKey:@"url"];
    
    [NSThread detachNewThreadSelector:@selector(startBackgroundLoadImage:) toTarget:self withObject:[dictionary autorelease]];
}

//calcule la taille min. Si l'image est plus grande que l'ecran fixe l'affichage de l'image.
- (void)setMinZoomScalesForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.minimumZoomScale = minScale;
    
    // si nous ne sommes pas en état de zoom, on se met en zoom mini
    if (self.zoomScale <= 1.0) {
        self.zoomScale = minScale;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];

    if (navigationBarController.state) {
        [navigationBarController hide];
    }
    else {
        [navigationBarController show];
    }
}

- (void)startBackgroundLoadImage:(id) dictionary {

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *url = [dictionary objectForKey:@"url"];

    NSURL* aURL = [NSURL URLWithString:url];
    NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];

    UIImage *image = [UIImage imageWithData:[data autorelease]];

    imageView = [[UIImageView alloc] initWithImage:image];

    [[NSOperationQueue mainQueue] addOperationWithBlock:
     ^(void) {
         [[FanartAppDelegate sharedAppDelegate] didStartNetworking];
         
         if (self) {
            [indicatorView stopAnimating];
             
            [self addSubview: imageView];
            [self setMinZoomScalesForCurrentBounds];
         }

         
         [[FanartAppDelegate sharedAppDelegate] didStopNetworking];
     }
     ];

    [pool release];

}

@end
