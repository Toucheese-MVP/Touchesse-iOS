module Fastlane
  module Actions
    class ChangelogUpdateAction < Action
      def self.run(params)
        version = params[:version]
        date = Time.now.strftime("%Y-%m-%d")

        release_notes_path = "fastlane/metadata/ko/release_notes.txt"
        changelog_path = "CHANGELOG.md"

        UI.message("릴리즈 노트를 CHANGELOG.md에 추가 중")

        unless File.exist?(release_notes_path)
          UI.user_error!("에러: release_notes.txt 파일이 존재하지 않음")
        end

        release_notes = File.read(release_notes_path)

        File.open(changelog_path, "a") do |file|
          file.puts "\n## #{version} (#{date})\n"
          file.puts release_notes
        end

        File.write(release_notes_path, <<~HEREDOC)
          ## 새로운 기능
          -

          ## 버그 수정
          -

          ## 개선 사항
          -
        HEREDOC

        UI.success("CHANGELOG.md 갱신, release_notes.txt 초기화 완료")
      end

      def self.description
        "릴리즈 노트를 CHANGELOG.md에 누적하고 release_notes.txt를 초기화합니다."
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "FL_CHANGELOG_VERSION",
            description: "기록할 버전 (예: 1.0.0)",
            optional: false,
            type: String
          )
        ]
      end
    end
  end
end

