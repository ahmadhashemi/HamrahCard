%hook CNContactStore

+ (NSInteger)authorizationStatusForEntityType:(NSInteger)entityType {
	return 3;
}

%end