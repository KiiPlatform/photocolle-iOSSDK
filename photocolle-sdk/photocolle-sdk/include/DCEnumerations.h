#ifndef PHOTOCOLLE_SDK_DCENUMERATIONS_H
#define PHOTOCOLLE_SDK_DCENUMERATIONS_H

/**
 The type of category to select tags.
 */
typedef NS_ENUM(NSInteger, DCCategory) {
    /** Category type to select all tags. */
    DCCATEGORY_ALL = 0,
    /** Category type to select person tags. */
    DCCATEGORY_PERSON = 1,
    /** Category type to select event tags. */
    DCCATEGORY_EVENT = 2,
    /** Category type to select favorite tags. */
    DCCATEGORY_FAVORITE = 3,
    /** Category type to select place tags. */
    DCCATEGORY_PLACEMENT = 4,
    /** Category type to select year month tags. */
    DCCATEGORY_YEAR_MONTH = 5
};

/**
 The type of a file.
 */
typedef NS_ENUM(NSInteger, DCFileType) {
    /** File type for all. */
    DCFILETYPE_ALL = 0,
    /** File type for image. */
    DCFILETYPE_IMAGE = 1,
    /** File type for video. */
    DCFILETYPE_VIDEO = 2,
    /** File type for slide movie. */
    DCFILETYPE_SLIDE_MOVIE = 3
};

/**
 The MIME type.
 */
typedef NS_ENUM(NSInteger, DCMimeType) {
    /** MIME type for jpeg. */
    DCMIMETYPE_JPEG = 1,
    /** MIME type for progressive jpeg. */
    DCMIMETYPE_PJPEG = 2,
    /** MIME type for 3gp. */
    DCMIMETYPE_THREE_GP = 3,
    /** MIME type for avi. */
    DCMIMETYPE_AVI = 4,
    /** MIME type for quick time. */
    DCMIMETYPE_QUICKTIME = 5,
    /** MIME type for mp4. */
    DCMIMETYPE_MP4 = 6,
    /** MIME type for vender spacific. */
    DCMIMETYPE_VND_MTS = 7,
    /** MIME type for mpeg. */
    DCMIMETYPE_MPEG = 8
};

/**
 The orientation of content.
 */
typedef NS_ENUM(NSInteger, DCOrientation) {
    /** 0 rotation. */
    DCORIENTATION_ROTATE_0 = 0,
    /** 90 rotation. */
    DCORIENTATION_ROTATE_90 = 90,
    /** 180 rotation. */
    DCORIENTATION_ROTATE_180 = 180,
    /** 270 rotation. */
    DCORIENTATION_ROTATE_270 = 270
};

/**
 The type of a projection.
 */
typedef NS_ENUM(NSInteger, DCProjectionType) {
    /** The count of files. */
    DCPROJECTIONTYPE_FILE_COUNT = 1,
    /** The detail information with all items. */
    DCPROJECTIONTYPE_ALL_DETAILS = 2,
    /** The detail information without tag. */
    DCPROJECTIONTYPE_DETAILS_WITHOUT_TAGS = 3
};

/**
 The type of a content resized or not.
 */
typedef NS_ENUM(NSInteger, DCResizeType) {
    /** Original content. */
    DCRESIZETYPE_ORIGINAL = 1,
    /** Resized image. */
    DCRESIZETYPE_RESIZED_IMAGE = 2,
    /** Resized video. */
    DCRESIZETYPE_RESIZED_VIDEO = 3
};

/**
 The type of 5 step evaluation score.
 */
typedef NS_ENUM(NSInteger, DCScore) {
    /** The highest score. */
    DCSCORE_SCORE_1 = 1,
    /** The high score. */
    DCSCORE_SCORE_2 = 2,
    /** The middle score. */
    DCSCORE_SCORE_3 = 3,
    /** The low score. */
    DCSCORE_SCORE_4 = 4,
    /** The lowest score. */
    DCSCORE_SCORE_5 = 5
};

/**
 The type of sort.
 */
typedef NS_ENUM(NSInteger, DCSortType) {
    /** Sort of descending order by creation date time. */
    DCSORTTYPE_CREATION_DATETIME_DESC = 1,
    /** Sort of ascending order by creation date time. */
    DCSORTTYPE_CREATION_DATETIME_ASC = 2,
    /** Sort of descending order by modification date time. */
    DCSORTTYPE_MODIFICATION_DATETIME_DESC = 3,
    /** Sort of ascending order by modification date time. */
    DCSORTTYPE_MODIFICATION_DATETIME_ASC = 4,
    /** Sort of ascending order by upload date time. */
    DCSORTTYPE_UPLOAD_DATETIME_ASC = 5,
    /** Sort of descending order by upload date time. */
    DCSORTTYPE_UPLOAD_DATETIME_DESC = 6,
    /** Sort of descending order by score. */
    DCSORTTYPE_SCORE_DESC = 7
};

/**
 The type of a tag.
 */
typedef NS_ENUM(NSInteger, DCTagType) {
    /** Tag type for person. */
    DCTAGTYPE_PERSON = 1,
    /** Tag type for event. */
    DCTAGTYPE_EVENT = 2,
    /** Tag type for favorite. */
    DCTAGTYPE_FAVORITE = 3,
    /** Tag type for placement. */
    DCTAGTYPE_PLACEMENT = 4,
    /** Tag type for years. */
    DCTAGTYPE_YEAR_MONTH = 5
};

#endif /*PHOTOCOLLE_SDK_DCENUMERATIONS_H*/
