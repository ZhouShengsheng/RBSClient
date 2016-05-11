#import "PopupView.h"
#import "Utils.h"

@interface PopupView ()

@end

@implementation PopupView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, 280, 135);
    
    self.confirm.layer.cornerRadius = 3;
    self.cancel.layer.cornerRadius = 3;
    self.msg_title.numberOfLines = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Initialize Theme Color
    [self initializeThemeColor];
    self.isDisplayng = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isDisplayng = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// Initialize Theme Color
- (void)initializeThemeColor {
    self.confirm.layer.backgroundColor = [UIColor alertColor].CGColor;
    self.cancel.layer.backgroundColor = [UIColor buttonBgColor].CGColor;
}

- (IBAction)confirm:(id)sender {
    [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
        if (self.confirmButtonPressedBlock)
            self.confirmButtonPressedBlock();
    }];
}

- (IBAction)cancel:(id)sender {
    [[KGModal sharedInstance] hideAnimated:YES withCompletionBlock:^{
        if (self.cancelButtonPressedBlock)
            self.cancelButtonPressedBlock();
    }];
}

- (void)dismiss {
    [[KGModal sharedInstance] hideAnimated:YES];
}

@end
