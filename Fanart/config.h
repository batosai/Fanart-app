//
//  config.h
//  Fanart
//
//  Created by Jérémy chaufourier on 07/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

/*
#define BASEURL  @"www.fan-art.fr"
#define API_KEY @"ea5af636cd2c0c07242ee43c07cbefbd"
#define API_DRAWINGS @"http://"BASEURL@"/app.php?v=1&key="API_KEY@"&controller=drawings"
#define API_DRAWINGS_FILTER API_DRAWINGS@"&filter=top"
#define API_DRAWINGS_CATEGORIES API_DRAWINGS@"&subcategory="

#define API_CATEGORIES @"http://"BASEURL@"/app.php?v=1&key="API_KEY@"&controller=categories"

#define API_VIEW_DRAWING @"http://"BASEURL@"/app.php?v=1&key="API_KEY@"&controller=trackingDrawing"@"&id="

#define API_LAUNCH @"http://"BASEURL@"/app.php?v=1&key="API_KEY@"&controller=launch"
*/


#define BASEURL  @"www.fan-art.fr"
#define API_KEY @"ea5af636cd2c0c07242ee43c07cbefbd"

#define API_NETWORK_TESTING @"http://"BASEURL@"/services/network?method=testing&format=json&key="API_KEY@"&v=1"

#define API_DRAWINGS @"http://"BASEURL@"/services/drawings?method=get&format=json&key="API_KEY@"&v=1"
#define API_DRAWINGS_FILTER API_DRAWINGS@"&filter=top"
#define API_DRAWINGS_CATEGORIES API_DRAWINGS@"&subcategory="

#define API_CATEGORIES @"http://"BASEURL@"/services/categories?method=get&format=json&key="API_KEY@"&v=1"

#define API_VIEW_DRAWING @"http://"BASEURL@"/services/tracking?method=drawing&format=json&key="API_KEY@"&v=1&id="

#define API_LAUNCH @"http://"BASEURL@"/services/tracking?method=launch&format=json&key="API_KEY@"&v=1"

