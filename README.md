# Photoline
This App Contains a Class to fetch images from IOS obj c Ver 7.0

How to use ?
Copy the Lib folder to your project

Return the Complete Data with a specific date range


    mz = [[MZAlubumReader alloc]init];
    mz.startdate =

    [mz fetch:^(NSMutableArray *response) {

	// Array of ALAsset for each date
		response //Sorted Images by Date

	//	Also Available

//mz.assetGroups;  // ALL ALBUMS
//mz.media;        // ALL IMAGES
//mz.ordermedia;   // Sorted Images by Date

    }];


//mz.startdate  // NSDate
//mz.endDate;   // NSDate
mz.allAlbum = YES/NO ;  // Fetch all Albums / Only Camera roll
mz.errorAlert=NO;       // Show Fetch Error




ALAsset * alAsset = [[_ordermedia objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    [mz getImage:alAsset :^(UIImage *image) {

        imageView.image= image;

    }];




