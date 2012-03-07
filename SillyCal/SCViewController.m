#import "SCViewController.h"

@implementation SCViewController

#pragma mark View Controller routines

- (void)dealloc
{
	[leftOprand release];
	[rightOprand release];
    [textLabel release];
	[operatorLabel release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		leftOprand = nil;
		rightOprand = nil;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.textLabel.text = rightOprand ? [rightOprand stringValue] : @"0";
	self.operatorLabel.text = @"";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	self.textLabel = nil;
	self.operatorLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark IBActions

- (IBAction)clear:(id)sender
{
	self.leftOprand = nil;
	self.rightOprand = nil;
	self.textLabel.text = @"0";
	self.operatorLabel.text = @"";
}
- (IBAction)appendText:(id)sender
{
	if (resetTextLabelOnNextAppending) {
		textLabel.text = @"0";
		resetTextLabelOnNextAppending = NO;
	}
	
	NSString *s = [(UIButton *)sender titleLabel].text;
	if ([s isEqualToString:@"."]) {
		if ([textLabel.text rangeOfString:@"."].location != NSNotFound) {
			return;
		}
		textLabel.text = [textLabel.text stringByAppendingString:s];
		return;
	}
	else if ([s isEqualToString:@"0"]) {
		if ([textLabel.text isEqualToString:@"0"]) {
			return;
		}
	}
	
	if ([textLabel.text isEqualToString:@"0"]) {
		textLabel.text = s;
	}
	else {
		textLabel.text = [textLabel.text stringByAppendingString:s];
	}
	
}
- (void)_doCalculation
{
	if (operatorSelector == NULL || !rightOprand) {
		return;
	}
	if (operatorSelector == @selector(decimalNumberByDividingBy:) && [rightOprand floatValue] == 0.0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to devide 0" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
		return;
	}
	NSDecimalNumber *result = [self.leftOprand performSelector:operatorSelector withObject:self.rightOprand];
	self.leftOprand = result;
	self.textLabel.text = [result stringValue];
	self.rightOprand = nil;
	resetTextLabelOnNextAppending = YES;
}

- (IBAction)setOperator:(id)sender
{	
	SEL selector = NULL;
	NSString *s = [(UIButton *)sender titleLabel].text;
	if ([s isEqualToString:@"+"]) {
		selector = @selector(decimalNumberByAdding:);
	}
	else if ([s isEqualToString:@"-"]) {
		selector = @selector(decimalNumberBySubtracting:);
	}
	else if ([s isEqualToString:@"*"]) {
		selector = @selector(decimalNumberByMultiplyingBy:);
	}
	else if ([s isEqualToString:@"/"]) {
		selector = @selector(decimalNumberByDividingBy:);
	}

	if (!self.leftOprand) {
		self.leftOprand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
		self.rightOprand = nil;
	}
	else if (!resetTextLabelOnNextAppending) {
		self.rightOprand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
		[self _doCalculation];
	}
	
	operatorSelector = selector;
	self.operatorLabel.text = s;
	resetTextLabelOnNextAppending = YES;
}

- (IBAction)doCalculation:(id)sender
{
	if (operatorSelector == NULL) {
		return;
	}
	if (!self.leftOprand) {
		return;
	}
	self.rightOprand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
	[self _doCalculation];
	self.operatorLabel.text = @"";
	operatorSelector = NULL;
}

#pragma mark Properties

@synthesize leftOprand, rightOprand;
@synthesize textLabel, operatorLabel;
@end
