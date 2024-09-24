//
//  LSBundleProxy.h
//  PeacockMenus
//
//  Created by He Cho on 2024/9/24.
//

#ifndef LSBundleProxy_h
#define LSBundleProxy_h


#endif /* LSBundleProxy_h */


#import <Foundation/Foundation.h>
/**
 *  A proxy for interacting with the bundle.
 */
@interface LSBundleProxy : NSObject
/**
 *  Returns the bundle proxy for the current process.
 *
 *  @return The bundle proxy.
 */
+ (nonnull LSApplicationProxy *)bundleProxyForCurrentProcess;
@end
