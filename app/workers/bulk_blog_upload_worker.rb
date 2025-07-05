require 'csv'
require 'open-uri'

class BulkBlogUploadWorker
  include Sidekiq::Worker

  def perform(file_path, user_id)
    user = User.find_by(id: user_id)
    return unless user

    CSV.foreach(file_path, headers: true) do |row|
      title       = row['title']&.strip
      description = row['description']&.strip
      image_url   = row['image_url']&.strip
      tags_string = row['tags']&.strip

      # Skip if required fields are blank
      next if title.blank? || description.blank?

      blog = user.blogs.create(
        title: title,
        description: description
        # Don't pass image_url directly unless it's a db field
      )

      next unless blog.persisted?

      # Attach image from remote URL (if present and using ActiveStorage)
      if image_url.present?
        begin
          downloaded_image = URI.open(image_url)
          blog.image.attach(
            io: downloaded_image,
            filename: File.basename(URI.parse(image_url).path),
            content_type: downloaded_image.content_type
          )
        rescue => e
          Rails.logger.error "Image attach failed for Blog ID #{blog.id}: #{e.message}"
        end
      end

      # Process tags with rank
      tags = tags_string.to_s.split(',').map(&:strip).reject(&:blank?)

      tags.each do |tag_with_rank|
        tag_name, rank_str = tag_with_rank.split(':').map(&:strip)
        next if tag_name.blank? || rank_str.blank?

        tag = Tag.find_or_create_by(name: tag_name)
        blog.blog_tags.create(tag: tag, rank: rank_str.to_i)
      end
    end
  ensure
    File.delete(file_path) if File.exist?(file_path)
  end
end
