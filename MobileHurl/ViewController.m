//
//  ViewController.m
//  MobileHurl
//
//  Created by Alexandr on 15.03.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "ViewController.h"
#import "RestManager.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *parametersView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;

- (IBAction)addButtonClickAction:(id)sender;
- (IBAction)requestButtonClickAction:(id)sender;

@property (strong, nonatomic) NSMutableArray *parametersNameArray;
@property (strong, nonatomic) NSMutableArray *parametersValueArray;
@property (strong, nonatomic) NSMutableArray *parametersCloseButtonArray;

@end

@implementation ViewController

#pragma mark - Public methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heightConstraint.constant = 0;
    
    self.parametersNameArray = [NSMutableArray array];
    self.parametersValueArray = [NSMutableArray array];
    self.parametersCloseButtonArray = [NSMutableArray array];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    self.URLTextField.text = @"http://api.openweathermap.org/data/2.5/weather";
    
    UITextField *textField = nil;
    [self createParameterAnimated];
    textField = [self.parametersNameArray lastObject];
    textField.text = @"id";
    textField = [self.parametersValueArray lastObject];
    textField.text = @"2988507";
    
    [self createParameterAnimated];
    textField = [self.parametersNameArray lastObject];
    textField.text = @"APPID";
    textField = [self.parametersValueArray lastObject];
    textField.text = @"d74e401b2d3f29456cae6b7830f70bc4";
}

#pragma mark - Actions

- (IBAction)addButtonClickAction:(id)sender {
    
    [self createParameterAnimated];
}

- (void)closeButtonClickAction:(UIButton*)sender {
    
    [self closeParameterAnimatedWithButton:sender];
}

- (IBAction)requestButtonClickAction:(id)sender {
    
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSURL *url = [NSURL URLWithString:self.URLTextField.text];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < self.parametersNameArray.count; i++) {
        NSString *value = [[self.parametersValueArray objectAtIndex:i] text];
        NSString *key = [[self.parametersNameArray objectAtIndex:i] text];
        [param setValue:value forKey:key];
    }
    
    [[RestManager sharedManager] getRequestToURL:url withParam:param success:^(NSDictionary *result) {
        NSLog(@"%@", result);
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Parameters

- (void)createParameterAnimated {
    
    NSUInteger index = self.parametersNameArray.count;
    
    UITextField *parametersName = [[UITextField alloc] init];
    parametersName.translatesAutoresizingMaskIntoConstraints = NO;
    parametersName.textAlignment = NSTextAlignmentCenter;
    parametersName.borderStyle = UITextBorderStyleRoundedRect;
    parametersName.placeholder = @"Name";
    parametersName.alpha = 0.f;
    [self.parametersView addSubview:parametersName];
    [self.parametersNameArray addObject:parametersName];
    
    UITextField *parametersValue = [[UITextField alloc] init];
    parametersValue.translatesAutoresizingMaskIntoConstraints = NO;
    parametersValue.textAlignment = NSTextAlignmentCenter;
    parametersValue.borderStyle = UITextBorderStyleRoundedRect;
    parametersValue.placeholder = @"Value";
    parametersValue.alpha = 0.f;
    [self.parametersView addSubview:parametersValue];
    [self.parametersValueArray addObject:parametersValue];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:@selector(closeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha = 0.f;
    [self.parametersView addSubview:closeButton];
    [self.parametersCloseButtonArray addObject:closeButton];
    
    [self.parametersView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[parametersName]-[closeButton(30)]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(parametersName, closeButton)]];
    
    [self.parametersView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[parametersValue]-[closeButton(30)]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(parametersValue, closeButton)]];
    
    [self.parametersView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[parametersName(30)]-[parametersValue(30)]"
                                             options:0
                                             metrics:@{@"offset": @((60 + 16 + 10)*index)}
                                               views:NSDictionaryOfVariableBindings(parametersValue, parametersName)]];
    
    [self.parametersView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[closeButton(30)]"
                                             options:0
                                             metrics:@{@"offset": @((60 + 16 + 10)*index + 19)}
                                               views:NSDictionaryOfVariableBindings(closeButton)]];
    
    
    CGFloat contentHeight = self.scrollView.contentSize.height;
    CGFloat navigationBarHeigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat parameterHeight = 60 + 16 + 10;
    CGFloat viewHeight = self.view.frame.size.height;
    __block CGPoint bottomOffset;
    
    [self.contentView layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        self.heightConstraint.constant += 60 + 16 + 10;
        [self.contentView layoutIfNeeded];
        if ((contentHeight + navigationBarHeigh + parameterHeight > viewHeight)) {
            bottomOffset = CGPointMake(0, contentHeight + navigationBarHeigh + parameterHeight - viewHeight);
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
    }];
    
    [UIView animateWithDuration:0.1f delay:0.2f options:0 animations:^{
        parametersName.alpha = 1.f;
        parametersValue.alpha = 1.f;
        closeButton.alpha = 1.f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeParameterAnimatedWithButton:(UIButton*)button {
    
    NSUInteger index = [self.parametersCloseButtonArray indexOfObject:button];
    
    UITextField *parametersName = [self.parametersNameArray objectAtIndex:index];
    UITextField *parametersValue = [self.parametersValueArray objectAtIndex:index];
    UIButton *closeButton = [self.parametersCloseButtonArray objectAtIndex:index];
    
    [UIView animateWithDuration:0.1f delay:0.f options:0 animations:^{
        parametersName.alpha = 0.f;
        parametersValue.alpha = 0.f;
        closeButton.alpha = 0.f;
    } completion:^(BOOL finished) {
        [parametersName removeFromSuperview];
        [parametersValue removeFromSuperview];
        [closeButton removeFromSuperview];
    }];
    
    CGFloat contentHeight = self.scrollView.contentSize.height;
    CGFloat navigationBarHeigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat parameterHeight = 60 + 16 + 10;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat contentOffset = self.scrollView.contentOffset.y;
    __block CGPoint bottomOffset;

    
    [self.parametersView layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{
        
        for (NSUInteger i = index + 1; i < self.parametersNameArray.count; i++) {
            
            UIView *textField = [self.parametersNameArray objectAtIndex:i];
            for (NSLayoutConstraint *con in self.parametersView.constraints) {
                if (con.firstItem == textField && con.firstAttribute == NSLayoutAttributeTop) {
                    con.constant -= 60 + 16 + 10;
                }
            }
            
            UIView *imageView = [self.parametersCloseButtonArray objectAtIndex:i];
            for (NSLayoutConstraint *con in self.parametersView.constraints) {
                if (con.firstItem == imageView && con.firstAttribute == NSLayoutAttributeTop) {
                    con.constant -= 60 + 16 + 10;
                }
            }
        }
        [self.parametersView layoutIfNeeded];
        
        self.heightConstraint.constant -= 60 + 16 + 10;
        [self.contentView layoutIfNeeded];
        
        if (contentHeight + navigationBarHeigh > viewHeight &&
            contentHeight + navigationBarHeigh - parameterHeight < viewHeight + contentOffset) {
            bottomOffset = CGPointMake(0, contentHeight + navigationBarHeigh - viewHeight - parameterHeight);
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
        
    } completion:^(BOOL finished) {
        [self.parametersNameArray removeObjectAtIndex:index];
        [self.parametersValueArray removeObjectAtIndex:index];
        [self.parametersCloseButtonArray removeObjectAtIndex:index];
    }];
}

@end
