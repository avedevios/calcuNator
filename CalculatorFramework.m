//
//  CalculatorFramework.m
//  calcuNator
//
//  Custom implementation replacing the simulator-only libCalculatorFramework.a
//

#import "CalculatorFramework.h"
#import <math.h>

@implementation CalculatorFramework {
    double _firstNumber;
    double _secondNumber;
    NSString *_operation;
    NSString *_trigFunction; // "sin", "cos", "tan"
    int _inputCount;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

- (void)inputNumber:(double)number {
    if (_inputCount == 0) {
        _firstNumber = number;
    } else {
        _secondNumber = number;
    }
    _inputCount++;
}

- (void)setOperation:(NSString *)operation {
    _operation = operation;
}

- (void)setTrigFunction:(NSString *)function {
    _trigFunction = function;
}

- (double)calculate {
    if ([_operation isEqualToString:@"+"]) return _firstNumber + _secondNumber;
    if ([_operation isEqualToString:@"-"]) return _firstNumber - _secondNumber;
    if ([_operation isEqualToString:@"×"]) return _firstNumber * _secondNumber;
    if ([_operation isEqualToString:@"÷"]) {
        if (_secondNumber == 0) return NAN;
        return _firstNumber / _secondNumber;
    }
    return NAN;
}

- (double)calculateTrigonometric {
    // Input is expected in degrees, convert to radians before calculation
    double radians = _firstNumber * M_PI / 180.0;
    if ([_trigFunction isEqualToString:@"sin"]) return sin(radians);
    if ([_trigFunction isEqualToString:@"cos"]) return cos(radians);
    if ([_trigFunction isEqualToString:@"tan"]) return tan(radians);
    return NAN;
}

- (void)clear {
    _firstNumber = 0;
    _secondNumber = 0;
    _operation = nil;
    _trigFunction = nil;
    _inputCount = 0;
}

@end
