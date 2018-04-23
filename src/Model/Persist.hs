module Model.Persist where

-- Prelude.
import           ClassyPrelude

import           Data.UUID            (UUID)
import           Database.Persist.TH  (mkMigrate, mkPersist, persistLowerCase,
                                       persistLowerCase, share, sqlSettings)
import Data.Text as T

-- Local imports.
import           Types.BCrypt         (BCrypt)
import           Types.Instances      ()
import           Types.User           (UName, UEmail, UBio, UImage)

--------------------------------------------------------------------------------
-- | Persistent model definition.
share
  [mkPersist sqlSettings
  , mkMigrate "migrateAll"
  ] [persistLowerCase|
  User sql=users
    name      UName        sqltype=text
    email     UEmail       sqltype=text
    bio       UBio   Maybe sqltype=text
    image     UImage Maybe sqltype=text
    uuid      UUID         sqltype=uuid
    createdAt UTCTime      sqltype=timestamptz sql=created_at default=CURRENT_TIMESTAMP
    updatedAt UTCTime      sqltype=timestamptz sql=updated_at default=CURRENT_TIMESTAMP
    UniqueEmailUser email
    deriving Eq Generic Show

  Password sql=passwords
    hash      BCrypt
    user      UserId
    createdAt UTCTime sqltype=timestamptz sql=created_at default=CURRENT_TIMESTAMP
    updatedAt UTCTime sqltype=timestamptz sql=updated_at default=CURRENT_TIMESTAMP
    UniquePasswordUser user

Vendor json
     name T.Text
     vendorOwnerId UserId
     UniqueVendorName name
     deriving Show
CourseType json
     courseType T.Text
     deriving Show
CourseCategory json
     name T.Text
     slug T.Text
     designationId DesignationId
     UniqueSlug slug
     deriving Show
Course json
     name T.Text
     vendorId VendorId
     catId CourseCategoryId
     courseType CourseTypeId
     deriving Show
CourseAttendance json
     dateStart UTCTime
     dateEnd UTCTime
     accCourseId AccreditedCourseId
     userId UserId
     deriving Show
AccreditedCourse json
    courseId CourseId
    designationId DesignationId
    credit Double
    approvedBy UserId
    duration Double
    expiryDate UTCTime
    reference String
    deriving Show Eq
Organization json
    name T.Text
    ownerId UserId
    deriving Show
Designation json
    name T.Text
    vendorId VendorId
    orgId OrganizationId
    cycleTime Int
    startDate UTCTime
    endDate UTCTime
    UniqueDesName name
    deriving Show Eq
DesignationRequirement json
    designationId DesignationId
    categoryId CourseCategoryId
    carryOver Int
    credit Int
    reqType RequirementTypeId
    deriving Show Eq
RequirementType
     name T.Text
     slug T.Text
     deriving Show Eq
WorkExperience json
    startDate UTCTime
    endDate UTCTime
    companyName T.Text
    title T.Text
    isCurrent Bool
    userId UserId
    deriving Show Eq
EducationExperience json
    startDate UTCTime
    endDate UTCTime
    institutionName T.Text
    title T.Text
    isCurrent Bool
    userId UserId
    deriving Show Eq
UserDesignation json
    startDate UTCTime
    endDate UTCTime
    institutionName T.Text
    conferredTitle T.Text
    title T.Text
    isCurrent Bool
    userId UserId
    deriving Show Eq


|]
