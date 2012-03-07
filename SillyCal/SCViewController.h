@interface SCViewController : UIViewController
{
	NSDecimalNumber *leftOprand;
	NSDecimalNumber *rightOprand;
	NSDecimalNumber *memory;
	SEL operatorSelector;
	BOOL resetTextLabelOnNextAppending;
	
	UILabel *textLabel;
	UILabel *operatorLabel;
}

- (IBAction)clear:(id)sender;
- (IBAction)appendText:(id)sender;
- (IBAction)setOperator:(id)sender;
- (IBAction)doCalculation:(id)sender;
- (IBAction)togglePositiveNegative:(id)sender;
- (IBAction)memoryClear:(id)sender;
- (IBAction)memoryPlus:(id)sender;
- (IBAction)memoryMinus:(id)sender;
- (IBAction)memoryRecall:(id)sender;

@property (retain, nonatomic) NSDecimalNumber *leftOprand;
@property (retain, nonatomic) NSDecimalNumber *rightOprand;
@property (retain, nonatomic) NSDecimalNumber *memory;
@property (retain, nonatomic) IBOutlet UILabel *textLabel;
@property (retain, nonatomic) IBOutlet UILabel *operatorLabel;

@end
