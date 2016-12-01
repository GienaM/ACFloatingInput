//
//  ACFloatingInput.m
//  Pods
//
//  Created by Robert Mietelski on 10.11.2016.
//  Copyright (c) 2016 mietelski-robert. All rights reserved.
//

#import "ACFloatingInput.h"

#import "ACTextField.h"
#import "ACTextView.h"

#import "ACTextInputView.h"
#import "ACTextInputLineView.h"

#import "UIImage+ACFloatingInput.h"
#import "NSString+ACFloatingInput.h"
#import "UIFont+ACFloatingInput.h"
#import "UIView+ACFloatingInput.h"

#define TEXT_INPUT_WRAPPER_VIEW_HEIGHT 34.0f

@interface ACFloatingInput ()<ACTextInputDelegate>

@property (nonatomic, strong, readonly) CATextLayer *placeholderLayer;
@property (nonatomic, strong, readonly) UIView *textInputWrapperView;
@property (nonatomic, strong, readonly) ACTextInputLineView *lineView;
@property (nonatomic, strong, readonly) UILabel *errorLabel;

@property (nonatomic, strong) NSLayoutConstraint *textInputViewTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textInputViewLeadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textInputViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textInputViewTrailingConstraint;

@end

@implementation ACFloatingInput

@synthesize placeholderText = _placeholderText;
@synthesize placeholderColor = _placeholderColor;
@synthesize placeholderFont = _placeholderFont;
@synthesize attributedPlaceholder = _attributedPlaceholder;

@synthesize text = _text;
@synthesize textColor = _textColor;
@synthesize textFont = _textFont;
@synthesize attributedText = _attributedText;

@synthesize errorText = _errorText;
@synthesize errorColor = _errorColor;
@synthesize errorFont = _errorFont;
@synthesize attributedError = _attributedError;

@synthesize selectedColor = _selectedColor;
@synthesize deselectedColor = _deselectedColor;

@synthesize inputAccessoryView = _inputAccessoryView;
@synthesize editing = _editing;

@synthesize textInputView = _textInputView;
@synthesize textInputInset = _textInputInset;

@synthesize delegate = _delegate;
@synthesize validationResult = _validationResult;

@synthesize borderStyle = _borderStyle;
@synthesize type = _type;

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;

@synthesize returnKeyType = _returnKeyType;
@synthesize keyboardType = _keyboardType;

@synthesize placeholderLayer = _placeholderLayer;
@synthesize textInputWrapperView = _textInputWrapperView;
@synthesize lineView = _lineView;
@synthesize errorLabel = _errorLabel;

@synthesize textInputViewTopConstraint = _textInputViewTopConstraint;
@synthesize textInputViewLeadingConstraint = _textInputViewLeadingConstraint;
@synthesize textInputViewBottomConstraint = _textInputViewBottomConstraint;
@synthesize textInputViewTrailingConstraint = _textInputViewTrailingConstraint;

#pragma mark -
#pragma mark Constructors

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonInit];
        [self setupConstraints];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonInit];
        [self setupConstraints];
    }
    return self;
}

- (void) commonInit {
    
    _placeholderText = @"Placeholder";
    _placeholderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    _placeholderFont = [UIFont systemFontOfSize:12.0f];
    
    _textColor = [UIColor blackColor];
    _textFont = [UIFont systemFontOfSize:14.0f];
    
    _errorColor = [UIColor redColor];
    _errorFont = [UIFont boldSystemFontOfSize:10.0f];
    
    _selectedColor = [UIColor colorWithRed:51.0/255.0 green:175.0/255.0 blue:236.0/255.0 alpha:1.0];
    _deselectedColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
    
    _textInputInset = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 5.0f);
    _editing = NO;
    
    _validationResult = ACTextValidationResultNone;
    _borderStyle = ACTextBorderStyleNone;
    _type = ACFloatingInputTypeText;
    
    _autocapitalizationType = UITextAutocapitalizationTypeNone;
    _autocorrectionType = UITextAutocorrectionTypeDefault;
    _returnKeyType = UIReturnKeyDefault;
    _keyboardType = UIKeyboardTypeDefault;
}

#pragma mark -
#pragma mark Managing constraints

- (void) setupConstraints {
    
    // errorLabel
    [NSLayoutConstraint constraintWithItem:self.errorLabel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:self.lineView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:2.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.errorLabel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.errorLabel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.errorLabel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    // lineView
    [NSLayoutConstraint constraintWithItem:self.lineView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.errorLabel
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.lineView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.errorLabel
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.lineView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.textInputWrapperView
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0
                                  constant:3.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.lineView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:1.5f].active = YES;
    
    // textInputWrapperView
    CGSize placeholderLayerSize = [self.attributedPlaceholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                           context:nil].size;
    
    [NSLayoutConstraint constraintWithItem:self.textInputWrapperView
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.errorLabel
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.textInputWrapperView
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.errorLabel
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1.0
                                  constant:0.0f].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.textInputWrapperView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0
                                  constant:placeholderLayerSize.height + 3].active = YES;
    
    [NSLayoutConstraint constraintWithItem:self.textInputWrapperView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:TEXT_INPUT_WRAPPER_VIEW_HEIGHT].active = YES;
}

- (void) updateConstraints {
    [super updateConstraints];
    
    if (!self.textInputViewTopConstraint) {
        self.textInputViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.textInputView
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.textInputWrapperView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:self.textInputInset.top];
        self.textInputViewTopConstraint.active = YES;
    }
    else {
        self.textInputViewTopConstraint.constant = self.textInputInset.top;
    }
    
    if (!self.textInputViewLeadingConstraint) {
        self.textInputViewLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.textInputView
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.textInputWrapperView
                                                                           attribute:NSLayoutAttributeLeading
                                                                          multiplier:1.0
                                                                            constant:self.textInputInset.left];
        self.textInputViewLeadingConstraint.active = YES;
    }
    else {
        self.textInputViewLeadingConstraint.constant = self.textInputInset.left;
    }
    
    if (!self.textInputViewBottomConstraint) {
        self.textInputViewBottomConstraint = [NSLayoutConstraint constraintWithItem:self.textInputWrapperView
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.textInputView
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0
                                                                        constant:self.textInputInset.bottom];
        self.textInputViewBottomConstraint.active = YES;
    }
    else {
        self.textInputViewBottomConstraint.constant = self.textInputInset.bottom;
    }
    
    if (!self.textInputViewTrailingConstraint) {
        self.textInputViewTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.textInputWrapperView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.textInputView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0
                                                                           constant:self.textInputInset.right];
        self.textInputViewTrailingConstraint.active = YES;
    }
    else {
        self.textInputViewTrailingConstraint.constant = self.textInputInset.right;
    }
}

#pragma mark -
#pragma mark Managing frames

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self.textInputView layoutIfNeeded];
    
    CGRect inputViewRect = UIEdgeInsetsInsetRect([self.textInputWrapperView convertRect:self.textInputView.inputView.frame toView:self], self.textInputInset);
    
    if (![self isEditing] && [NSString isEmpty:self.attributedText.string]) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.attributedPlaceholder.string
                                                                               attributes:[self attributesWithFontRef:[self.textFont CTFont]
                                                                                                         textColorRef:[self.placeholderColor CGColor]]];
        
        self.placeholderLayer.frame = [self placeholderPositionAsTextWithAttributedString:attributedString
                                                                            inputViewRect:inputViewRect];
    }
    else {
        self.placeholderLayer.frame = [self placeholderPositionAsHintWithAttributedString:self.attributedPlaceholder
                                                                            inputViewRect:inputViewRect];
    }
}

#pragma mark -
#pragma mark Access methods

- (void) setPlaceholderText:(NSString *)other {
    
    // Save property
    _placeholderText = [other copy];
    
    // Update user interface
    self.placeholderLayer.string = other;
}

- (void) setPlaceholderColor:(UIColor *)other {
    
    // Save property
    _placeholderColor = [other copy];
    
    // Update user interface
    if (![self isEditing] && [NSString isEmpty:self.attributedText.string]) {
        self.placeholderLayer.foregroundColor = other.CGColor;
    }
}

- (void) setPlaceholderFont:(UIFont *)other {
    
    // Save property
    _placeholderFont = [other copy];
    
    // Update user interface
    if ([self isEditing] || ![NSString isEmpty:self.attributedText.string]) {
        
        self.placeholderLayer.font = CGFontCreateWithFontName((CFStringRef)other.fontName);
        self.placeholderLayer.fontSize = other.pointSize;
    }
    [self layoutIfNeeded];
}

- (void) setAttributedPlaceholder:(NSAttributedString *)other {
    
    // Save property
    _attributedError = [other copy];
    
    // Update user interface
    self.placeholderLayer.string = other;
}

- (NSAttributedString *) attributedPlaceholder {
    
    if (!_attributedPlaceholder) {
        if (![NSString isEmpty:self.placeholderText]) {
            NSDictionary *attributes = [self attributesWithFontRef:[self.placeholderFont CTFont]
                                                      textColorRef:[self.placeholderColor CGColor]];
            
            return [[NSAttributedString alloc] initWithString:self.placeholderText
                                                   attributes:attributes];
        }
    }
    return _attributedPlaceholder;
}

- (void) setText:(NSString *)other {
    
    // Save property
    _text = [other copy];
    
    // Update user interface
    if ([self isEditing]) {
        [self configurePlaceholderForActiveFocus];
    }
    else {
        [self configurePlaceholderForInactiveFocus];
    }
    self.textInputView.inputView.text = other;
}

- (void) setTextColor:(UIColor *)other {
    
    // Save property
    _textColor = [other copy];
    
    // Update user interface
    self.textInputView.inputView.textColor = other;
}

- (void) setTextFont:(UIFont *)other {
    
    // Save property
    _textFont = [other copy];
    
    // Update user interface
    self.textInputView.inputView.font = other;
}

- (void) setAttributedText:(NSAttributedString *)other {
    
    // Save property
    _attributedText = [other copy];
    
    // Update user interface
    self.textInputView.inputView.attributedText = other;
}

- (NSAttributedString *) attributedText {
    
    if (!_attributedText) {
        if (![NSString isEmpty:self.text]) {
            NSDictionary *attributes = [self attributesWithFont:self.textFont
                                                      textColor:self.textColor];
            
            return [[NSAttributedString alloc] initWithString:self.text
                                                   attributes:attributes];
        }
    }
    return _attributedText;
}

- (void) setErrorText:(NSString *)other {
    
    // Save property
    _errorText = [other copy];
    
    // Update user interface
    self.errorLabel.text = other;
}

- (void) setErrorColor:(UIColor *)other {
    
    // Save property
    _errorColor = [other copy];
    
    // Update user interface
    self.errorLabel.textColor = other;
}

- (void) setErrorFont:(UIFont *)other {
    
    // Save property
    _errorFont = [other copy];
    
    // Update user interface
    self.errorLabel.font = other;
}

- (void) setAttributedError:(NSAttributedString *)other {
    
    // Save property
    _attributedError = [other copy];
    
    // Update user interface
    self.errorLabel.attributedText = other;
}

- (NSAttributedString *) attributedError {
    
    if (!_attributedError) {
        if (![NSString isEmpty:self.errorText]) {
            NSDictionary *attributes = [self attributesWithFont:self.errorFont
                                                      textColor:self.errorColor];
            
            return [[NSAttributedString alloc] initWithString:self.errorText
                                                   attributes:attributes];
        }
    }
    return _attributedError;
}

- (void) setSelectedColor:(UIColor *)other {
    
    // Save property
    _selectedColor = [other copy];
    
    // Update user interface
    if (![self isEditing] && [NSString isEmpty:self.attributedText.string]) {
        self.textInputView.inputView.tintColor = other;
    }
    else {
        self.placeholderLayer.foregroundColor = other.CGColor;
        self.lineView.defaultColor = other;
    }
}

- (void) setDeselectedColor:(UIColor *)other {
    
    // Save property
    _deselectedColor = [other copy];
    
    // Update user interface
    if (![self isEditing] && [NSString isEmpty:self.attributedText.string]) {
        self.lineView.defaultColor = other;
    }
    else {
        self.textInputView.inputView.tintColor = other;
    }
}

- (void) setInputAccessoryView:(UIView *)other {
    
    // Save property
    _inputAccessoryView = other;
    
    // Update user interface
    self.textInputView.inputView.inputAccessoryView = other;
}

- (void) setTextInputInset:(UIEdgeInsets)other {
    
    // Save property
    _textInputInset = other;
    
    // Update user interface
    [self setNeedsUpdateConstraints];
}

- (void) setValidationResult:(ACTextValidationResult)other {
    
    // Save property
    _validationResult = other;
    
    // Update user interface
    switch (other) {
        case ACTextValidationResultNone:
        case ACTextValidationResultPassed:
            
            self.textInputView.inputView.textColor = self.textColor;
            break;
            
        case ACTextValidationResultFailed:
            
            self.textInputView.inputView.textColor = self.errorColor;
            break;
            
        default:
            break;
    }
}

- (void) setBorderStyle:(ACTextBorderStyle)other {
    
    // Save property
    _borderStyle = other;
    
    // Update user interface
    switch (other) {
        case ACTextBorderStyleNone:
            
            self.textInputWrapperView.layer.borderColor = [UIColor clearColor].CGColor;
            self.textInputWrapperView.layer.borderWidth = 0.0f;
            self.textInputWrapperView.layer.cornerRadius = 0.0f;
            break;
            
        case ACTextBorderStyleLine:
            
            self.textInputWrapperView.layer.borderColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0].CGColor;
            self.textInputWrapperView.layer.borderWidth = 1.0f;
            self.textInputWrapperView.layer.cornerRadius = 0.0f;
            break;
            
        case ACTextBorderStyleRoundedRect:
            
            self.textInputWrapperView.layer.borderColor = [UIColor colorWithRed:160.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:1.0].CGColor;
            self.textInputWrapperView.layer.borderWidth = 1.0f;
            self.textInputWrapperView.layer.cornerRadius = 5.0f;
            break;
            
        default:
            break;
    }
}

- (void) setType:(ACFloatingInputType)other {
    
    // Save property
    _type = other;
    
    // Update user interface
    if (_textInputView != nil) {
        _textInputView.inputView = [self inputViewForType:other];
    }
}

- (void) setAutocapitalizationType:(UITextAutocapitalizationType)other {
    
    // Save property
    _autocapitalizationType = other;
    
    // Update user interface
    self.textInputView.inputView.autocapitalizationType = other;
}

- (void) setAutocorrectionType:(UITextAutocorrectionType)other {
    
    // Save property
    _autocorrectionType = other;
    
    // Update user interface
    self.textInputView.inputView.autocorrectionType = other;
}

- (void) setReturnKeyType:(UIReturnKeyType)other {
    
    // Save property
    _returnKeyType = other;
    
    // Update user interface
    self.textInputView.inputView.returnKeyType = other;
}

- (void) setKeyboardType:(UIKeyboardType)other {
    
    // Save property
    _keyboardType = other;
    
    // Update user interface
    self.textInputView.inputView.keyboardType = other;
}

- (void)shake {
    self.layer.transform = CATransform3DMakeTranslation(20.0, 0.0, 0.0);
    
    [UIView animateWithDuration:0.8
                          delay:0.0
         usingSpringWithDamping:0.2
          initialSpringVelocity:0.8
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.layer.transform = CATransform3DIdentity;
                     } completion:^(BOOL finished) {
                         self.layer.transform = CATransform3DIdentity;
                     }];
}

#pragma mark -
#pragma mark Managing subviews

- (CATextLayer *) placeholderLayer {
    
    if (!_placeholderLayer) {
        
        _placeholderLayer = [CATextLayer layer];
        _placeholderLayer.masksToBounds = NO;
        _placeholderLayer.contentsScale = [UIScreen mainScreen].scale;
        _placeholderLayer.backgroundColor = [UIColor clearColor].CGColor;
        _placeholderLayer.font = CGFontCreateWithFontName((CFStringRef)self.placeholderFont.fontName);
        _placeholderLayer.foregroundColor = self.placeholderColor.CGColor;
        _placeholderLayer.fontSize = self.placeholderFont.pointSize;
        _placeholderLayer.string = self.placeholderText;
        [self.layer addSublayer:_placeholderLayer];
    }
    return _placeholderLayer;
}

- (UIView *) textInputWrapperView {
    
    if (!_textInputWrapperView) {
        
        _textInputWrapperView = [[UIControl alloc] init];
        _textInputWrapperView.translatesAutoresizingMaskIntoConstraints = NO;
        _textInputWrapperView.backgroundColor = [UIColor clearColor];
        [self addSubview:_textInputWrapperView];
    }
    return _textInputWrapperView;
}

- (ACTextInputView *) textInputView {
    
    if (!_textInputView) {
        
        _textInputView = [[ACTextInputView alloc] init];
        _textInputView.translatesAutoresizingMaskIntoConstraints = NO;
        _textInputView.inputView = [self inputViewForType:self.type];
        _textInputView.backgroundColor = [UIColor clearColor];
        _textInputView.clipsToBounds = YES;
        
        [_textInputView addTarget:self action:@selector(textInputSelected:)
                 forControlEvents:UIControlEventTouchUpInside];
        [_textInputView addTarget:self action:@selector(textInputPressed:)
                 forControlEvents:UIControlEventTouchDown];
        [_textInputView addTarget:self action:@selector(textInputReleased:)
                 forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        
        [self.textInputWrapperView addSubview:_textInputView];
    }
    return _textInputView;
}

- (ACTextInputLineView *) lineView {
    
    if (!_lineView) {
        
        _lineView = [[ACTextInputLineView alloc] init];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *) errorLabel {
    
    if (!_errorLabel) {
        
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _errorLabel.backgroundColor = [UIColor clearColor];
        _errorLabel.attributedText = self.attributedError;
        _errorLabel.textColor = self.errorColor;
        _errorLabel.font = self.errorFont;
        _errorLabel.numberOfLines = 0;
        [self addSubview:_errorLabel];
    }
    return _errorLabel;
}

#pragma mark -
#pragma mark Actions

- (void) changeSecureTextEntry:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [self.textInputView.inputView resignFirstResponder];
    [self.textInputView.inputView setSecureTextEntry:!sender.selected];
    [self.textInputView.inputView becomeFirstResponder];
}

- (void) textInputSelected:(UIControl *)sender {
    
    if (self.type == ACFloatingInputTypeSelection) {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputDidSelect:)]){
            [self.delegate floatingInputDidSelect:self];
        }
    }
    else {
        [self.textInputView.inputView becomeFirstResponder];
    }
}

- (void) textInputPressed:(UIControl *)sender {
    self.textInputWrapperView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
}

- (void) textInputReleased:(UIControl *)sender {
    self.textInputWrapperView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark Implementation of the protocol ACTextInputDelegate

- (void) textInputDidBeginEditing:(UIView<ACTextInput>* _Nonnull)textInput {
    _editing = YES;
    
    [self movePlaceholderWithAnimations:^{
        [self configurePlaceholderForActiveFocus];
    }];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputDidBeginEditing:)]){
        [self.delegate floatingInputDidBeginEditing:self];
    }
}

- (void) textInputDidEndEditing:(UIView<ACTextInput>* _Nonnull)textInput {
    _editing = NO;
    
    [self movePlaceholderWithAnimations:^{
        [self configurePlaceholderForInactiveFocus];
    }];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputDidEndEditing:)]){
        [self.delegate floatingInputDidEndEditing:self];
    }
}

- (void) textInputDidChange:(UIView<ACTextInput>* _Nonnull)textInput {
    _text = [textInput.text copy];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputDidChange:)]){
        [self.delegate floatingInputDidChange:self];
    }
}

- (BOOL) textInput:(UIView<ACTextInput>* _Nonnull)textInput shouldChangeTextInRange:(NSRange)range replacementText:(NSString * _Nullable)text {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInput:shouldChangeTextInRange:replacementText:)]){
        [self.delegate floatingInput:self shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (BOOL) textInputShouldBeginEditing:(UIView<ACTextInput>* _Nonnull)textInput {
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputShouldBeginEditing:)]){
        [self.delegate floatingInputShouldBeginEditing:self];
    }
    return YES;
}

- (BOOL) textInputShouldEndEditing:(UIView<ACTextInput>* _Nonnull)textInput {
 
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputShouldEndEditing:)]){
        [self.delegate floatingInputShouldEndEditing:self];
    }
    return YES;
}

- (BOOL) textInputShouldReturn:(UIView<ACTextInput>* _Nonnull)textInput {
 
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(floatingInputShouldReturn:)]){
        [self.delegate floatingInputShouldReturn:self];
    }
    return YES;
}

#pragma mark -
#pragma mark Managing the Responder Chain

- (BOOL) canBecomeFirstResponder {
    return [self.textInputView.inputView canBecomeFirstResponder];
}

- (BOOL) becomeFirstResponder {
    return [self.textInputView.inputView becomeFirstResponder];
}

- (BOOL) canResignFirstResponder {
    return [self.textInputView.inputView canResignFirstResponder];
}

- (BOOL) resignFirstResponder {
    return [self.textInputView.inputView resignFirstResponder];
}

- (BOOL) isFirstResponder {
    return [self.textInputView.inputView isFirstResponder];
}

#pragma mark -
#pragma mark Managing placeholder

- (CGRect) placeholderPositionAsHintWithAttributedString:(NSAttributedString *)attributedString inputViewRect:(CGRect)inputViewRect {
    
    const CGRect placeholderLayerRect = [attributedString boundingRectWithSize:CGSizeMake(inputViewRect.size.width, MAXFLOAT)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                       context:nil];
    
    return CGRectMake(inputViewRect.origin.x,
                      0.0f,
                      inputViewRect.size.width,
                      placeholderLayerRect.size.height);
}

- (CGRect) placeholderPositionAsTextWithAttributedString :(NSAttributedString *)attributedString inputViewRect:(CGRect)inputViewRect {
    
    const CGFloat textInputViewHeight = TEXT_INPUT_WRAPPER_VIEW_HEIGHT - self.textInputInset.top - self.textInputInset.bottom;
    const CGRect placeholderLayerRect = [attributedString boundingRectWithSize:CGSizeMake(inputViewRect.size.width, MAXFLOAT)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                       context:nil];
    
    return CGRectMake(inputViewRect.origin.x,
                      inputViewRect.origin.y + ((textInputViewHeight - placeholderLayerRect.size.height) * 0.5f),
                      inputViewRect.size.width,
                      placeholderLayerRect.size.height);
}

- (void) configurePlaceholderForActiveFocus {
    CGRect inputViewRect = UIEdgeInsetsInsetRect([self.textInputWrapperView convertRect:self.textInputView.inputView.frame toView:self], self.textInputInset);
    
    self.placeholderLayer.frame = [self placeholderPositionAsHintWithAttributedString:self.attributedPlaceholder
                                                                        inputViewRect:inputViewRect];
    
    self.placeholderLayer.fontSize = self.placeholderFont.pointSize;
    self.placeholderLayer.font = CGFontCreateWithFontName((CFStringRef)self.placeholderFont.fontName);
    self.placeholderLayer.foregroundColor = self.selectedColor.CGColor;
    
    [self.lineView animateFillLineWithColor:self.selectedColor];
}

- (void) configurePlaceholderForInactiveFocus {
    CGRect inputViewRect = UIEdgeInsetsInsetRect([self.textInputWrapperView convertRect:self.textInputView.inputView.frame toView:self], self.textInputInset);
    
    if ([NSString isEmpty:self.attributedText.string]) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.attributedPlaceholder.string
                                                                               attributes:[self attributesWithFontRef:[self.textFont CTFont]
                                                                                                         textColorRef:[self.placeholderColor CGColor]]];
        
        self.placeholderLayer.frame = [self placeholderPositionAsTextWithAttributedString:attributedString
                                                                            inputViewRect:inputViewRect];
        
        self.placeholderLayer.fontSize = self.textFont.pointSize;
        self.placeholderLayer.font = CGFontCreateWithFontName((CFStringRef)self.textFont.fontName);
        self.placeholderLayer.foregroundColor = self.placeholderColor.CGColor;
    }
    else {
        self.placeholderLayer.frame = [self placeholderPositionAsHintWithAttributedString:self.attributedPlaceholder
                                                                            inputViewRect:inputViewRect];
        
        self.placeholderLayer.fontSize = self.placeholderFont.pointSize;
        self.placeholderLayer.font = CGFontCreateWithFontName((CFStringRef)self.placeholderFont.fontName);
        self.placeholderLayer.foregroundColor = self.placeholderColor.CGColor;
    }
    [self.lineView animateEmptyLine];
}

- (void) movePlaceholderWithAnimations:(void (^)())animations {
    
    [UIView transactionAnimationWithDuration:0.2f
                               timingFuncion:[CAMediaTimingFunction functionWithControlPoints:0.3f :0.0f :0.5f :0.95f]
                                  animations:animations];
}

#pragma mark -
#pragma mark Helper methods

- (NSDictionary *) attributesWithFontRef:(CTFontRef)fontRef textColorRef:(CGColorRef)colorRef {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (fontRef != nil) {
        [attributes setObject:(__bridge id _Nonnull)(fontRef) forKey:(__bridge NSString *)kCTFontAttributeName];
    }
    if (colorRef != nil) {
        [attributes setObject:(__bridge id _Nonnull)(colorRef) forKey:(__bridge NSString *)kCTForegroundColorAttributeName];
    }
    return [NSDictionary dictionaryWithDictionary:attributes];
}

- (NSDictionary *) attributesWithFont:(UIFont *)font textColor:(UIColor *)color {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (font != nil) {
        [attributes setObject:font forKey:NSFontAttributeName];
    }
    if (color != nil) {
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
    }
    return [NSDictionary dictionaryWithDictionary:attributes];
}

- (UIView<ACTextInput> *) inputViewForType:(ACFloatingInputType)type {
    UIView<ACTextInput> *inputView = nil;
    
    switch (type) {
        case ACFloatingInputTypeText: {
            
            ACTextField *textField = [[ACTextField alloc] init];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            inputView = textField;
            break;
        }
        case ACFloatingInputTypePassword: {
            
            UIImage *image = [UIImage imageNamed:@"input_preview_password_icon"];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 25.0f, 35.0f)];
            [button setImage:[image imageWithTintColor:self.deselectedColor] forState:UIControlStateNormal];
            [button setImage:[image imageWithTintColor:self.selectedColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(changeSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
            [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
            
            ACTextField *textField = [[ACTextField alloc] init];
            textField.rightViewMode = UITextFieldViewModeWhileEditing;
            textField.secureTextEntry = YES;
            textField.rightView = button;
            
            inputView = textField;
            break;
        }
        case ACFloatingInputTypeSelection: {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 15.0f, 15.0f)];
            imageView.image = [UIImage imageNamed:@"arrow_down_icon"];
            
            ACTextField *textField = [[ACTextField alloc] init];
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.userInteractionEnabled = NO;
            textField.rightView = imageView;
            
            inputView = textField;
            break;
        }
        case ACFloatingInputTypeMultiline: {
            
            ACTextView *textView = [[ACTextView alloc] init];
            textView.backgroundColor = [UIColor clearColor];
            textView.textContainerInset = UIEdgeInsetsMake(8.0f, 0.0, 8.0f, 0.0f);
            textView.textContainer.lineFragmentPadding = 0;
            
            inputView = textView;
            break;
        }
        default:
            break;
    }
    
    inputView.font = self.textFont;
    inputView.textColor = self.textColor;
    inputView.attributedText = self.attributedText;
    inputView.inputAccessoryView = self.inputAccessoryView;
    inputView.autocapitalizationType = self.autocapitalizationType;
    inputView.autocorrectionType = self.autocorrectionType;
    inputView.returnKeyType = self.returnKeyType;
    inputView.keyboardType = self.keyboardType;
    inputView.textInputDelegate = self;
    
    return inputView;
}

@end