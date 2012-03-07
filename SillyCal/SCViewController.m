#import "SCViewController.h"

@implementation SCViewController

#pragma mark View Controller routines

- (void)dealloc
{
	[leftOprand release], [rightOprand release], [memory release];
	[textLabel release], [operatorLabel release];
	[super dealloc];
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
		if ([textLabel.text rangeOfString:@"."].location == NSNotFound) {
			textLabel.text = [textLabel.text stringByAppendingString:s];
		}
		return;
	}
	if ([textLabel.text isEqualToString:@"0"]) {
		if ([s isEqualToString:@"0"]) {
			return;
		}
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to devide 0!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
	if (!self.leftOprand) {
		self.leftOprand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
		self.rightOprand = nil;
	}
	else if (!resetTextLabelOnNextAppending) {
		self.rightOprand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
		[self _doCalculation];
	}

	NSString *s = [(UIButton *)sender titleLabel].text;
	NSDictionary *keySelectorMap = [NSDictionary dictionaryWithObjectsAndKeys:
						@"decimalNumberByAdding:", @"+",
						@"decimalNumberBySubtracting:", @"-",
						@"decimalNumberByMultiplyingBy:", @"*",
						@"decimalNumberByDividingBy:", @"/", nil];	
	operatorSelector = NSSelectorFromString([keySelectorMap objectForKey:s]);
	self.operatorLabel.text = s;
	resetTextLabelOnNextAppending = YES;
}

- (IBAction)doCalculation:(id)sender
{
	if (operatorSelector == NULL || !self.leftOprand) {
		return;
	}
	self.rightOprand = [NSDecimalNumber decimalNumberWithString:self.textLabel.text];
	[self _doCalculation];
	self.operatorLabel.text = @"";
	operatorSelector = NULL;
}

- (IBAction)togglePositiveNegative:(id)sender
{
	if (resetTextLabelOnNextAppending) {
		self.leftOprand = nil;
		resetTextLabelOnNextAppending = NO;
	}
	NSString *s = self.textLabel.text;
	self.textLabel.text = [s hasPrefix:@"-"] ? [s substringFromIndex:1] : [@"-" stringByAppendingString:s];
}

- (IBAction)memoryClear:(id)sender
{
	self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
}

- (IBAction)memoryPlus:(id)sender
{
	if (!self.memory) {
		self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
	}
	self.memory = [self.memory decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:self.textLabel.text]];
	resetTextLabelOnNextAppending = YES;
}

- (IBAction)memoryMinus:(id)sender
{
	if (!self.memory) {
		self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
	}
	self.memory = [self.memory decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.textLabel.text]];
	resetTextLabelOnNextAppending = YES;
}

- (IBAction)memoryRecall:(id)sender
{
	if (!self.memory) {
		self.memory = [NSDecimalNumber decimalNumberWithString:@"0"];
	}
	self.textLabel.text = [self.memory stringValue];
	if (!operatorSelector) {
		self.leftOprand = [[self.memory copy] autorelease];
	}
	resetTextLabelOnNextAppending = YES;
}

#pragma mark Properties

@synthesize leftOprand, rightOprand, memory;
@synthesize textLabel, operatorLabel;
@end
