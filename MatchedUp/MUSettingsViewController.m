//
//  MUSettingsViewController.m
//  MatchedUp
//
//  Created by Alex Paul on 12/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "MUSettingsViewController.h"

@interface MUSettingsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UISlider *ageSlider;
@property (strong, nonatomic) IBOutlet UISwitch *menSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *womenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *singleSwitch;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *editProfileButton;

@end

@implementation MUSettingsViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.ageSlider.value = [[NSUserDefaults standardUserDefaults] integerForKey:kMUAgeMaxKey];
    self.menSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUMenEnabledKey];
    self.womenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUWomenEnabledKey];
    self.singleSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kMUSingleEnabledKey];
    
    [self.ageSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.menSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.womenSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.singleSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [PFUser logOut];
    
    [self.navigationController popToRootViewControllerAnimated:YES]; 
}

- (IBAction)editProfileButtonPressed:(UIButton *)sender
{
    
}

#pragma mark - Helper Methods
- (void)valueChanged:(id)sender
{
    if (sender == self.ageSlider) {
        [[NSUserDefaults standardUserDefaults] setInteger:self.ageSlider.value forKey:kMUAgeMaxKey];
        self.ageLabel.text = [NSString stringWithFormat:@"%i", (int)self.ageSlider.value];
    }else if (sender == self.menSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.menSwitch.isOn forKey:kMUMenEnabledKey];
        
    }else if (sender == self.womenSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.womenSwitch.isOn forKey:kMUWomenEnabledKey];
        
    }else if (sender == self.singleSwitch) {
        [[NSUserDefaults standardUserDefaults] setBool:self.singleSwitch.isOn forKey:kMUSingleEnabledKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
