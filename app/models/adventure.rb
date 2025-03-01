class Adventure < ActiveRecord::Base
    belongs_to :user

    has_many :pictures, :dependent => :destroy

    has_attached_file :image, styles: { small: "50x50", med: "200x200", large: "400x400", xlarge: "700x900" }

    validates_attachment :image,
        content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] },
        size: { in: 0..10.megabytes }

    accepts_nested_attributes_for :pictures, :reject_if => lambda { |t| t['picture'].nil? }

    def image_from_url(url)
        self.image = open(url)
    end

end
