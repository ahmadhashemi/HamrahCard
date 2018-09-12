@interface _TtC10HamrahCard6FPCard : NSObject
@property(nonatomic, copy) NSString *pan;
@end

@interface _TtC10HamrahCard18FPCardCarouselView : UIView
@property(nonatomic, readonly) _TtC10HamrahCard6FPCard *currentCard;
@end

@interface _TtC10HamrahCard17FPCustomTextField : UITextField
@end

@interface _TtC10HamrahCard30FPServiceTabPageViewController : UIViewController
@property(nonatomic) __weak _TtC10HamrahCard18FPCardCarouselView *cardCarousel;
@end

@interface _TtC10HamrahCard18FPSecondPassDialog
@property(nonatomic) __weak UILabel *titleLabel;
@property(nonatomic) __weak _TtC10HamrahCard17FPCustomTextField *secondPassTextField;
@property(nonatomic) __weak _TtC10HamrahCard17FPCustomTextField *cv2TextField;
@end

//

static NSString *selectedCardPan;

%hook _TtC10HamrahCard30FPServiceTabPageViewController

- (void)onSendMoneyTapped:(id)arg1 {

    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SavedCards"];

	selectedCardPan = self.cardCarousel.currentCard.pan;
	%orig;

}

- (void)onPayBillTapped:(id)arg1 {

    selectedCardPan = self.cardCarousel.currentCard.pan;
    %orig;

}

- (void)onBalanceTapped:(id)arg1 {

    selectedCardPan = self.cardCarousel.currentCard.pan;
    %orig;

}

- (void)onTransactionsTapped:(id)arg1 {

    selectedCardPan = nil;
    %orig;

}

- (void)onInternetPackagesTapped:(id)arg1 {

    selectedCardPan = nil;
    %orig;

}

- (void)onSimChargeTapped:(id)arg1 {

    selectedCardPan = nil;
    %orig;

}

- (void)onReceiveMoneyTapped:(id)arg1 {

    selectedCardPan = nil;
    %orig;

}

- (void)onCardTappedWithCard:(id)arg1 {

    selectedCardPan = nil;
    %orig;

}

%end

%hook _TtC10HamrahCard18FPSecondPassDialog

- (void)viewWillAppear:(_Bool)arg1 {

	%orig;

	//

    if (!selectedCardPan) {
        return;
    }

	NSArray *savedCards = [[NSUserDefaults standardUserDefaults] objectForKey:@"SavedCards"];

    for (NSDictionary *savedCard in savedCards) {
        
        NSString *checkPan = savedCard[@"pan"];
        
        if (![checkPan isEqualToString:selectedCardPan]) {
            continue;
        }
        
        NSString *secondPass = savedCard[@"secondPass"];
        NSString *cv2 = savedCard[@"cv2"];

        if (secondPass) {
            self.secondPassTextField.text = secondPass;
        }

        if (cv2) {
            self.cv2TextField.text = cv2;
        }

    }

}

- (void)onConfirmedClicked:(id)arg1 {

	%orig;

	//

    if (!selectedCardPan) {
        return;
    }

	NSString *secondPass = self.secondPassTextField.text;
	NSString *cv2 = self.cv2TextField.text;

	NSMutableArray *savedCards = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SavedCards"] mutableCopy];
	if (!savedCards) { savedCards = [[NSMutableArray alloc] init]; }
	
	NSInteger loopIndex = 0;
	NSInteger cardIndex = -1;

    for (NSDictionary *savedCard in savedCards) {
        
        NSString *checkPan = savedCard[@"pan"];
        
        if ([checkPan isEqualToString:selectedCardPan]) {
        	cardIndex = loopIndex;
            break;
        }

        loopIndex++;

    }

    if (cardIndex != -1) {
    	[savedCards removeObjectAtIndex:cardIndex];
    }

	NSMutableDictionary *newCard = @{@"pan":selectedCardPan}.mutableCopy;
    if (secondPass) {
        newCard[@"secondPass"] = secondPass;
    }
    if (cv2) {
        newCard[@"cv2"] = cv2;
    }
	[savedCards addObject:newCard];

	[[NSUserDefaults standardUserDefaults] setObject:savedCards forKey:@"SavedCards"];
	[[NSUserDefaults standardUserDefaults] synchronize];

}

%end

%hook CNContactStore

+ (NSInteger)authorizationStatusForEntityType:(NSInteger)entityType {
    return 3;
}

%end