#import <Foundation/Foundation.h>
#import <objc/runtime.h>

static id (*orig_INVocabulary_sharedVocabulary)(id self, SEL _cmd);
static id hooked_INVocabulary_sharedVocabulary(id self, SEL _cmd) {
    return nil;
}

static void (*orig_INVocabulary_setVocabularyStrings)(id self, SEL _cmd, id strings, NSInteger type);
static void hooked_INVocabulary_setVocabularyStrings(id self, SEL _cmd, id strings, NSInteger type) {
}

__attribute__((constructor))
static void initSiriBypass(void) {
    @autoreleasepool {
        Class inVocabularyClass = objc_getClass("INVocabulary");
        if (inVocabularyClass) {
            Class metaClass = object_getClass((id)inVocabularyClass);
            SEL selShared = sel_registerName("sharedVocabulary");
            Method methodShared = class_getClassMethod(inVocabularyClass, selShared);
            if (methodShared) {
                orig_INVocabulary_sharedVocabulary = (id (*)(id, SEL))method_getImplementation(methodShared);
                method_setImplementation(methodShared, (IMP)hooked_INVocabulary_sharedVocabulary);
            }

            SEL selSetVocab = sel_registerName("setVocabularyStrings:ofType:");
            Method methodSetVocab = class_getInstanceMethod(inVocabularyClass, selSetVocab);
            if (methodSetVocab) {
                orig_INVocabulary_setVocabularyStrings = (void (*)(id, SEL, id, NSInteger))method_getImplementation(methodSetVocab);
                method_setImplementation(methodSetVocab, (IMP)hooked_INVocabulary_setVocabularyStrings);
            }
        }
    }
}
