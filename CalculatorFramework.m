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
    int _inputCount; // tracks whether we're setting first or second number
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
    // Trig is handled in CalculatorEngine (degrees → radians conversion)
    return NAN;
}

- (void)clear {
    _firstNumber = 0;
    _secondNumber = 0;
    _operation = nil;
    _inputCount = 0;
}

@end
