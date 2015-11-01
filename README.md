# Photoline
This App Contains a Class to fetch images from IOS obj c Ver 7.0

How to use ?
Copy the Lib folder to your project

Return the Complete Data with a specific date range


[super viewDidLoad];
    mz = [[MZAlubumReader alloc]init];
    [mz fetch:^(NSMutableArray *response) {
	// Array of ALAsset for each date
    }];


ALAsset * alAsset = [[_ordermedia objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [mz getImage:alAsset :^(UIImage *image) {
        imageView.image= image;
    }];

