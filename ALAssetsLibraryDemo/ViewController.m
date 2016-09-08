//
//  ViewController.m
//  ALAssetsLibraryDemo
//
//  Created by MengLong Wu on 16/9/8.
//  Copyright © 2016年 MengLong Wu. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ViewController ()
{
    NSMutableArray          *_images;
    
    NSMutableArray          *_urls;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    AssetsLibrary 多媒体文件管理框架，管理图片和视频文件
//    iOS 8.0之后使用Photos框架，但是为了兼容iOS 7，所以现在还依然使用AssetsLibrary框架
    
//    ALAssetsLibrary 图片库的文件夹
//    ALAssetsGroup 图片分类文件
//    ALAssets 图片
    
    _urls = [NSMutableArray array];
    
    _images = [NSMutableArray array];
    
//    1.获取图片库资源
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]init];
    
//    2.遍历图片库 异步
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
//        获取分类文件夹的名字
        NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];
        
        NSLog(@"%@",name);
        
//        3.如果group存在，对group进行遍历
        if (group) {
//            4.遍历文件夹下所有存在的图片
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
//                   5.如果result存在，对图片进行处理
//                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
////                        判断如果资源是图片类型
//                    }
//                    获取缩略图
                    UIImage *image = [[UIImage alloc]initWithCGImage:result.thumbnail];
                    
//                    获取原图
//                    ALAssetRepresentation *representation = result.defaultRepresentation;
//                    UIImage *oImage = [[UIImage alloc]initWithCGImage:[representation fullScreenImage]];
                    
//                    都是获取缩略图展示，获取原图的url保存起来，需要展示原图的时候，就根据url得到原图用于展示
                    
//                    获取图片的url
                    NSURL *url = [result valueForProperty:ALAssetPropertyAssetURL];
                    
//                    添加url
                    [_urls addObject:url];
//                    添加缩略图
                    [_images addObject:image];
                }
                
            }];
        }else{
//            group已经没有了 说明遍历结束
//            在这里可以对数组进行使用了
            
            [self createScrollViewWithArray:_images];
        }
        
        
    } failureBlock:^(NSError *error) {
        
        
    }];
    
    
//    获取到图片的url
    NSURL *url = [_urls objectAtIndex:1];
//    获取图片库
    ALAssetsLibrary *assetsLibrary1 = [[ALAssetsLibrary alloc]init];
//  根据url获取一张图片
    [assetsLibrary1 assetForURL:url resultBlock:^(ALAsset *asset) {
        
        ALAssetRepresentation *r = asset.defaultRepresentation;
//        获取大图
        UIImage *image = [[UIImage alloc]initWithCGImage:[r fullScreenImage]];
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)createScrollViewWithArray:(NSArray *)array
{
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-20, 80)];
    
    scroll.contentSize = CGSizeMake(80*array.count, 80);
    
    for (int i = 0; i<array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80*i, 0, 80, 80)];
        imageView.image = [_images objectAtIndex:i];
        [scroll addSubview:imageView];
    }
    
    [self.view addSubview:scroll];
}
















@end
