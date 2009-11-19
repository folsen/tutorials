/*
* AppController.j
* NewApplication
*
* Created by You on July 5, 2009.
* Copyright 2009, Your Company All rights reserved.
*/

@import <Foundation/CPObject.j>

var DownloadIFrame = null,
		DownloadSlotNext = null;

@implementation FButtonView : CPView
{
	[self super];
}

-(void)setObjectValue:anID
{
	//create download button and add as subview to second column
	downloadImage = [[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"download.png"]];
	[downloadImage setSize:CGSizeMake(20,20)];
	downloadButton = [[CPButton alloc] initWithFrame:CGRectMake( 0, 0, 20, 20 )];
	[downloadButton setBordered:NO];
	[downloadButton setImage:downloadImage];
	[downloadButton setAlternateImage:downloadImage];
	[downloadButton setImagePosition:CPImageOnly];
	[downloadButton setTarget:self];
	[downloadButton setTag:anID];
	[downloadButton setAction:@selector(downloader:)];
	[downloadButton sendActionOn:CPLeftMouseUpMask];
	[self addSubview:downloadButton];
}

- (void)downloader:(id)aButton
{
	if (DownloadIFrame == null)
	{
		DownloadIFrame = document.createElement("iframe");
		DownloadIFrame.style.position = "absolute";
		DownloadIFrame.style.top    = "-100px";
		DownloadIFrame.style.left   = "-100px";
		DownloadIFrame.style.height = "0px";
		DownloadIFrame.style.width  = "0px";
		document.body.appendChild(DownloadIFrame);
	}
	
	var now = new Date().getTime(),
			downloadSlot = (DownloadSlotNext && DownloadSlotNext > now)  ? DownloadSlotNext : now;
			
	DownloadSlotNext = downloadSlot + 2000;
	window.setTimeout(function() {
		if (DownloadIFrame != null)
			DownloadIFrame.src = "http://localhost:3000/uploads/"+[aButton tag];
		}, downloadSlot - now);
}


@end