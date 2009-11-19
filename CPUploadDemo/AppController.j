/*
* AppController.j
* CPUploadDemo
*
* Created by ique on July 5, 2009.
*/

@import <Foundation/CPObject.j>
@import "FileUpload.j"
@import "FButtonView.j"

@implementation AppController : CPObject
{
	CPTextField label;
	CPTableView tableView;
	CPArray files;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
	// send off a request for the file-list
	request = [[CPURLRequest alloc] initWithURL:@"http://localhost:3000/uploads"]; ;
	[CPURLConnection connectionWithRequest:request delegate:self];
	
	// set up the window and create a variable to access the contentView a bit easier
	var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask],
	contentView = [theWindow contentView];

	// create the label and position it
	label = [[CPTextField alloc] initWithFrame:CGRectMakeZero()]
	[label setStringValue:@"Hello, upload something!"];
	[label setFont:[CPFont boldSystemFontOfSize:24.0]];
	[label sizeToFit];
	[label setCenter:CGPointMake(CGRectGetWidth([contentView frame])/2.0, 20)];
	[label setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin];

	// add the label to the window
	[contentView addSubview:label];

	// create a CPScrollView that will contain the CPTableView
	var scrollView = [[CPScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth([contentView bounds])/2-150, 50.0, 300.0, CGRectGetHeight([contentView bounds])-100)];
	[scrollView setAutohidesScrollers:YES];
	[scrollView setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewHeightSizable];

	// create the CPTableView
	tableView = [[CPTableView alloc] initWithFrame:[scrollView bounds]];
	[tableView setDataSource:self];
	[tableView setUsesAlternatingRowBackgroundColors:YES];
	
	// define the header color
	var headerColor = [CPColor colorWithPatternImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"button-bezel-center.png"]]];
	[[tableView cornerView] setBackgroundColor:headerColor];
	
	// add the filename column
	var column = [[CPTableColumn alloc] initWithIdentifier:@"Filename"];
	[[column headerView] setStringValue:"Filename"];
	[[column headerView] setBackgroundColor:headerColor];
	[column setWidth:280.0];
	[tableView addTableColumn:column];
  
	// add the downloadbutton column
	var downloadColumn = [[CPTableColumn alloc] initWithIdentifier:"Download"];
	[downloadColumn setWidth:20];
	[[downloadColumn headerView] setBackgroundColor:headerColor];
	[downloadColumn setDataView:[[FButtonView alloc] initWithFrame:CGRectMake( 0, 0, 20, 20 )]];
	[tableView addTableColumn:downloadColumn];
	
	// set the tableview as the documentview of scrollview
	[scrollView setDocumentView:tableView];
	
	// add the scrollView to the window
	[contentView addSubview:scrollView];
	
	// create and set up the upload button
	uploadButton = [[UploadButton alloc] initWithFrame: CGRectMakeZero()] ;
	[uploadButton setTitle:@"Select File"] ;
	[uploadButton setName:@"upload[attachment]"]
	[uploadButton setURL:@"http://localhost:3000/uploads/create"];
	[uploadButton setDelegate: self];
	[uploadButton setAutoresizingMask:CPViewMinXMargin | CPViewMaxXMargin | CPViewMinYMargin];
	[uploadButton setBordered:YES];
	[uploadButton sizeToFit];
	[uploadButton setCenter:CGPointMake(CGRectGetWidth([contentView bounds])/2.0, CGRectGetHeight([contentView bounds])-25)];
	
	// add the uploadbutton to the window
	[contentView addSubview:uploadButton];

	[theWindow orderFront:self];
}

// CPTableView datasource methods
- (int)numberOfRowsInTableView:(CPTableView)tableView
{
	return [files count];
}

- (id)tableView:(CPTableView)tableView objectValueForTableColumn:(CPTableColumn)tableColumn row:(int)row
{
	if([tableColumn identifier] == "Filename") {
		return [files objectAtIndex:row].upload.attachment_file_name;		
	}	else {
		return [files objectAtIndex:row].upload.id;
	}
}

// UploadButton methods
- (void)uploadButton: uploadButton didChangeSelection: selection
{
	[uploadButton submit];
}
- (void)uploadButton: uploadButton didFinishUploadWithData: response
{
	[label setStringValue:@"File uploaded!"];
	[label sizeToFit];
	files = [files arrayByAddingObject:CPJSObjectCreateWithJSON(response)];
	[tableView reloadData];
	[label setCenter:[[theWindow contentView] center]];
}

// Connection handlers
- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
	//get a javascript object from the json response
	files = CPJSObjectCreateWithJSON(data);
	[tableView reloadData];
	//clear out this connection's reference
	[self clearConnection:aConnection];
}

- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPString)error
{
	alert("There was an error getting the list of uploaded files.");

	[self clearConnection:aConnection];
}

- (void)clearConnection:(CPURLConnection)aConnection
{
	_deletePhotoConnection = nil;
}

@end
