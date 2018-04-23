describe Fastlane::Actions::PromoCodeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The promo_code plugin is working!")

      Fastlane::Actions::PromoCodeAction.run(nil)
    end
  end
end
