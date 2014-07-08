@interface NoteObject : NSObject
-(BOOL)isPlainText;
-(NSString *)contentAsPlainText;
-(NSString *)content;
-(NSString *)contentAsPlainTextPreservingNewlines;
@end

@interface NotesListController : UIViewController 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
-(NoteObject *)noteAtIndex:(unsigned int)index;
-(UITableView *)table;
@end

unsigned int selectedIndex = 0;

%hook NotesListController

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

UITableViewCell *cell = %orig;

UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self 
action:@selector(longPressedCell:)];
[cell addGestureRecognizer:longPress];
//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
return cell;

}

%new

-(void)longPressedCell:(UILongPressGestureRecognizer *)gestureRecognizer {

if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {

UITableViewCell *pressedCell = (UITableViewCell *)[gestureRecognizer view];

selectedIndex = [[self table] indexPathForCell:pressedCell].row;

[[UIMenuController sharedMenuController] 
setTargetRect:CGRectMake(pressedCell.center.x,pressedCell.center.y,0,0) inView:[self table]];
UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"Copy Note" action:@selector(copySelectedNote:)];
[[UIMenuController sharedMenuController] setMenuItems:@[copyItem]];
[[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];

}

}

%new

-(void)copySelectedNote:(id)sender {

NoteObject *selectedNote = [self noteAtIndex:selectedIndex];

[[UIPasteboard generalPasteboard] setString:[selectedNote contentAsPlainTextPreservingNewlines]];

}

%new
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copySelectedNote:));
}

%new
-(BOOL)canBecomeFirstResponder {
    return TRUE;
}


%end
