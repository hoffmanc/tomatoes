require 'application_system_test_case'

class InvoicesTest < ApplicationSystemTestCase
  setup do
    User.delete_all
  end

  def add_tomato(t, *tags)
    @user.tomatoes.create! created_at: t, tags: tags
  end

  def assert_value(val)
    assert all("input[value='#{val}']").any?
  end

  test 'allows user to create and edit invoice' do
    @user = User.create! email: 'foo@example.com'

    add_tomato '2001-1-2 00:00:00', 'have the same', 'tag names'
    add_tomato '2001-1-2 01:00:00', 'have the same', 'tag names'
    add_tomato '2001-1-2 03:00:00', 'different tag same day'

    add_tomato '2001-1-3 00:00:00', 'have the same', 'tag names'

    add_tomato '2001-12-30 23:59:59', 'before_date_range'
    add_tomato '2001-1-15 00:00:00', 'after_date_range'

    visit signin_path(:twitter)

    click_on 'New Invoice'
    fill_in 'Period Starts On', with: pstart = '2001-01-01'
    fill_in 'Period Ends On', with: pend = '2001-01-14'
    click_on 'Create Invoice'
    assert_text "Period: #{pstart} to #{pend}"

    assert_no_text 'before_date_range'

    within('div#date_2001_01_02') do
      assert_text 'Jan 02'

      within('li.invoice-entry-have-the-same-tag-names') do
        assert_text 'have the same'
        assert_text 'tag names'
        assert_value(1.0)
        fill_in 'Hours', with: '1.25'
        fill_in 'Description',
          with: @started_work = 'started work on this task and worked on it for an hour'
      end

      within('li.invoice-entry-different-tag-same-day') do
        assert_text 'different tag same day'
        assert_value(0.5)
        fill_in 'Hours', with: '0.25'
        fill_in 'Description', with: @finished = 'was able to finish this task in one half hour'
      end
    end

    within('div#date_2001_01_03') do
      assert_text 'Jan 03'

      within('li.invoice-entry-have-the-same-tag-names') do
        assert_text 'have the same'
        assert_text 'tag names'
        assert_value(0.5)
        fill_in 'Hours', with: '1.5'
        fill_in 'Description', with: @continued = 'continued this task today'
      end
    end

    assert_text 'Total Hours: 2.0'
    assert_no_text 'after_date_range'

    click_on 'Update Invoice'

    within 'div#date_2001_01_02' do
      within 'li.invoice-entry-have-the-same-tag-names textarea' do
        assert_text @started_work
      end

      within 'li.invoice-entry-different-tag-same-day textarea' do
        assert_text @finsihed
      end
    end
    within 'div#date_2001_01_03 li.invoice-entry-have-the-same-tag-names textarea' do
      assert_text @continued
    end
    assert_text 'Total Hours: 3.0'
  end
end
