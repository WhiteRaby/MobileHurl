//
//  ViewController.m
//  MobileHurl
//
//  Created by Alexandr on 15.03.16.
//  Copyright © 2016 Alexandr. All rights reserved.
//

#import "ViewController.h"
#import "RestManager.h"
#import "ResultViewController.h"

@interface ViewController () 

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *parametersView;
@property (weak, nonatomic) IBOutlet UIView *headersView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *URLTextField;
@property (weak, nonatomic) IBOutlet UIButton *addParameterButton;
@property (weak, nonatomic) IBOutlet UIButton *addHeaderButton;


- (IBAction)addParameterButtonClickAction:(id)sender;
- (IBAction)addHeaderButtonClickAction:(id)sender;

- (IBAction)requestButtonClickAction:(id)sender;

@property (strong, nonatomic) NSMutableArray *parametersNameArray;
@property (strong, nonatomic) NSMutableArray *parametersValueArray;
@property (strong, nonatomic) NSMutableArray *parametersCloseButtonArray;

@property (strong, nonatomic) NSMutableArray *headersNameArray;
@property (strong, nonatomic) NSMutableArray *headersValueArray;
@property (strong, nonatomic) NSMutableArray *headersCloseButtonArray;

@end

@implementation ViewController

#pragma mark - Public methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Mobile Hurl";
    
    self.parametersNameArray = [NSMutableArray array];
    self.parametersValueArray = [NSMutableArray array];
    self.parametersCloseButtonArray = [NSMutableArray array];
    
    self.headersNameArray = [NSMutableArray array];
    self.headersValueArray = [NSMutableArray array];
    self.headersCloseButtonArray = [NSMutableArray array];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    self.URLTextField.text = @"http://api.openweathermap.org/data/2.5/weather";
    
    UITextField *textField = nil;
    //[self addParametersAnimated];
    [self addParameterButtonClickAction:nil];
    textField = [self.parametersNameArray lastObject];
    textField.text = @"id";
    textField = [self.parametersValueArray lastObject];
    textField.text = @"2988507";
    
    [self addParameterButtonClickAction:nil];
    textField = [self.parametersNameArray lastObject];
    textField.text = @"APPID";
    textField = [self.parametersValueArray lastObject];
    textField.text = @"d74e401b2d3f29456cae6b7830f70bc4";
}

#pragma mark - Actions

- (IBAction)addParameterButtonClickAction:(id)sender {
    
    SEL selector = @selector(closeParameterButtonClickAction:);
    
    [self createTextFieldPairInNamesArray:self.parametersNameArray
                              valuesArray:self.parametersValueArray
                             buttonsArray:self.parametersCloseButtonArray
                           targetSelector:selector
                                     view:self.parametersView];
    
    CGFloat navigationBarHeigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat parameterHeight = 60 + 16 + 10;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat contentOffset = self.scrollView.contentOffset.y;
    __block CGPoint bottomOffset;
    
    [self.contentView layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        if (CGRectGetMaxY(self.addParameterButton.frame) + parameterHeight + 20.f > viewHeight + contentOffset + navigationBarHeigh) {
            bottomOffset = CGPointMake(0, CGRectGetMaxY(self.addParameterButton.frame) + parameterHeight + 20.f - viewHeight - navigationBarHeigh);
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
    }];
}

- (void)closeParameterButtonClickAction:(UIButton*)sender {
    
    NSUInteger index = [self.parametersCloseButtonArray indexOfObject:sender];
    
    [self deleteTextFieldPairAtIndex:index
                        InNamesArray:self.parametersNameArray
                         valuesArray:self.parametersValueArray
                        buttonsArray:self.parametersCloseButtonArray
                                view:self.parametersView];
}

- (IBAction)addHeaderButtonClickAction:(id)sender {
    
    SEL selector = @selector(closeHeaderButtonClickAction:);
    
    [self createTextFieldPairInNamesArray:self.headersNameArray
                              valuesArray:self.headersValueArray
                             buttonsArray:self.headersCloseButtonArray
                           targetSelector:selector
                                     view:self.headersView];
    
    CGFloat navigationBarHeigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat parameterHeight = 60 + 16 + 10;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat contentOffset = self.scrollView.contentOffset.y;
    __block CGPoint bottomOffset;
    
    [self.contentView layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        if (CGRectGetMaxY(self.addHeaderButton.frame) + parameterHeight + 20.f > viewHeight + contentOffset + navigationBarHeigh) {
            bottomOffset = CGPointMake(0, CGRectGetMaxY(self.addHeaderButton.frame) + parameterHeight + 20.f - viewHeight - navigationBarHeigh);
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
    }];
}

- (void)closeHeaderButtonClickAction:(UIButton*)sender {

    NSUInteger index = [self.headersCloseButtonArray indexOfObject:sender];
    
    [self deleteTextFieldPairAtIndex:index
                        InNamesArray:self.headersNameArray
                         valuesArray:self.headersValueArray
                        buttonsArray:self.headersCloseButtonArray
                                view:self.headersView];
}

- (IBAction)requestButtonClickAction:(id)sender {
    
    NSURL *url = [NSURL URLWithString:self.URLTextField.text];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < self.parametersNameArray.count; i++) {
        NSString *value = [[self.parametersValueArray objectAtIndex:i] text];
        NSString *key = [[self.parametersNameArray objectAtIndex:i] text];
        [param setValue:value forKey:key];
    }
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    for (NSUInteger i = 0; i < self.headersNameArray.count; i++) {
        NSString *value = [[self.headersValueArray objectAtIndex:i] text];
        NSString *key = [[self.headersNameArray objectAtIndex:i] text];
        [headers setValue:value forKey:key];
    }
    
    [[RestManager sharedManager]
     getRequestToURL:url
     withParam:param
     headers:headers
     success:^(NSString *result) {
         
         ResultViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             [vc.textView setText:result];
         });
         
         [self.navigationController pushViewController:vc animated:YES];
         vc.title = @"Response";
         
     } failure:^(NSError *error) {
         NSLog(@"%@", error);
     }];
}




#pragma mark - TextFieldPair

- (void)createTextFieldPairInNamesArray:(NSMutableArray*)parametersNameArray
                            valuesArray:(NSMutableArray*)parametersValueArray
                           buttonsArray:(NSMutableArray*)parametersCloseButtonArray
                         targetSelector:(SEL)selector
                                   view:(UIView*)mainView {
    
    NSUInteger index = parametersNameArray.count;
    
    UITextField *parametersName = [[UITextField alloc] init];
    parametersName.translatesAutoresizingMaskIntoConstraints = NO;
    parametersName.textAlignment = NSTextAlignmentCenter;
    parametersName.font = [UIFont systemFontOfSize:14.f];
    parametersName.borderStyle = UITextBorderStyleRoundedRect;
    parametersName.placeholder = @"Name";
    parametersName.alpha = 0.f;
    [mainView addSubview:parametersName];
    [parametersNameArray addObject:parametersName];
    
    UITextField *parametersValue = [[UITextField alloc] init];
    parametersValue.translatesAutoresizingMaskIntoConstraints = NO;
    parametersValue.textAlignment = NSTextAlignmentCenter;
    parametersValue.font = [UIFont systemFontOfSize:14.f];
    parametersValue.borderStyle = UITextBorderStyleRoundedRect;
    parametersValue.placeholder = @"Value";
    parametersValue.alpha = 0.f;
    [mainView addSubview:parametersValue];
    [parametersValueArray addObject:parametersValue];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [closeButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    closeButton.alpha = 0.f;
    [mainView addSubview:closeButton];
    [parametersCloseButtonArray addObject:closeButton];
    
    [mainView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[parametersName]-[closeButton(30)]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(parametersName, closeButton)]];
    
    [mainView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(20)-[parametersValue]-[closeButton(30)]-(20)-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(parametersValue, closeButton)]];
    
    [mainView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[parametersName(30)]-[parametersValue(30)]"
                                             options:0
                                             metrics:@{@"offset": @((60 + 16 + 10)*index)}
                                               views:NSDictionaryOfVariableBindings(parametersValue, parametersName)]];
    
    [mainView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(offset)-[closeButton(30)]"
                                             options:0
                                             metrics:@{@"offset": @((60 + 16 + 10)*index + 19)}
                                               views:NSDictionaryOfVariableBindings(closeButton)]];
    
    [UIView animateWithDuration:0.1f delay:0.2f options:0 animations:^{
        parametersName.alpha = 1.f;
        parametersValue.alpha = 1.f;
        closeButton.alpha = 1.f;
    } completion:nil];
    
    [self.contentView layoutIfNeeded];
    [UIView animateWithDuration:0.3f animations:^{
        for (NSLayoutConstraint *con in mainView.constraints) {
            if (con.firstAttribute == NSLayoutAttributeHeight && con.firstItem == mainView) {
                con.constant += 60 + 16 + 10;
            }
        }
        [self.contentView layoutIfNeeded];
    }];
}

- (void)deleteTextFieldPairAtIndex:(NSUInteger)index
                      InNamesArray:(NSMutableArray*)parametersNameArray
                       valuesArray:(NSMutableArray*)parametersValueArray
                      buttonsArray:(NSMutableArray*)parametersCloseButtonArray
                              view:(UIView*)mainView {
    
    UITextField *parametersName = [parametersNameArray objectAtIndex:index];
    UITextField *parametersValue = [parametersValueArray objectAtIndex:index];
    UIButton *closeButton = [parametersCloseButtonArray objectAtIndex:index];
    
    [parametersNameArray removeObjectAtIndex:index];
    [parametersValueArray removeObjectAtIndex:index];
    [parametersCloseButtonArray removeObjectAtIndex:index];
    
    CGFloat contentHeight = self.scrollView.contentSize.height;
    CGFloat navigationBarHeigh = self.navigationController.navigationBar.frame.size.height;
    CGFloat parameterHeight = 60 + 16 + 10;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat contentOffset = self.scrollView.contentOffset.y;
    __block CGPoint bottomOffset;
    
    [UIView animateWithDuration:0.1f delay:0.f options:0 animations:^{
        parametersName.alpha = 0.f;
        parametersValue.alpha = 0.f;
        closeButton.alpha = 0.f;
    } completion:^(BOOL finished) {
        [parametersName removeFromSuperview];
        [parametersValue removeFromSuperview];
        [closeButton removeFromSuperview];
    }];
    
    [mainView layoutIfNeeded];
    [self.contentView layoutIfNeeded];
    [UIView animateWithDuration:0.3f delay:0.f options:0 animations:^{

        for (NSUInteger i = index; i < parametersNameArray.count; i++) {
            
            UIView *textField = [parametersNameArray objectAtIndex:i];
            for (NSLayoutConstraint *con in mainView.constraints) {
                if (con.firstItem == textField && con.firstAttribute == NSLayoutAttributeTop) {
                    con.constant -= 60 + 16 + 10;
                }
            }
            
            UIView *imageView = [parametersCloseButtonArray objectAtIndex:i];
            for (NSLayoutConstraint *con in mainView.constraints) {
                if (con.firstItem == imageView && con.firstAttribute == NSLayoutAttributeTop) {
                    con.constant -= 60 + 16 + 10;
                }
            }
        }
        
        for (NSLayoutConstraint *con in mainView.constraints) {
            if (con.firstAttribute == NSLayoutAttributeHeight && con.firstItem == mainView) {
                con.constant -= 60 + 16 + 10;
            }
        }
        
        if (contentHeight > viewHeight - navigationBarHeigh &&
            contentHeight + navigationBarHeigh - parameterHeight < viewHeight + contentOffset) {
            bottomOffset = CGPointMake(0, CGRectGetMaxY(self.addHeaderButton.frame) + 20.f - viewHeight - navigationBarHeigh);
            [self.scrollView setContentOffset:bottomOffset animated:NO];
        }
        
        if (contentHeight > viewHeight - navigationBarHeigh - parameterHeight &&
            !(contentHeight > viewHeight - navigationBarHeigh)) {
            [self.scrollView setContentOffset:CGPointMake(0.f, -64.f) animated:NO];
        }
        
        [self.contentView layoutIfNeeded];
        [mainView layoutIfNeeded];
    } completion:nil];
}




@end
