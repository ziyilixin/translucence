
#import <UIKit/UIKit.h>

typedef enum {
    BSTopicTypeAll = 1,
    BSTopicTypePicture = 10,
    BSTopicTypeWord = 29,
    BSTopicTypeVoice = 31,
    BSTopicTypeVideo = 41,
} BSTopicType;

/** 精华-顶部标题的高度 */
UIKIT_EXTERN CGFloat const BSTitlesViewH;
/** 精华-顶部标题的Y值 */
UIKIT_EXTERN CGFloat const BSTitlesViewY;

/** 精华-cell-间距 */
UIKIT_EXTERN CGFloat const BSTopicCellMargin;
/** 精华-cell-文字内容的Y值 */
UIKIT_EXTERN CGFloat const BSTopicCellTextY;
/** 精华-cell-底部工具条的高度 */
UIKIT_EXTERN CGFloat const BSTopicCellBottomBarH;

/** 精华-cell-图片帖子的最大高度 */
UIKIT_EXTERN CGFloat const BSTopicCellPictureMaxH;
/** 精华-cell-图片帖子一旦超过最大高度,就是用Break */
UIKIT_EXTERN CGFloat const BSTopicCellPictureBreakH;
